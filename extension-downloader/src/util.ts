import chalk, { Chalk } from "chalk";
import fs from "fs";
import https from "https";
import { MultiProgressBars } from "multi-progress-bars";
import path from "path";
import yauzl from "yauzl";
import { colors, folderRegex } from "./constants";
import { Extension, ExtensionRegistry, OpenVSXAPIResponse } from "./types.js";

export const trim = (string: string, length?: number): string => {
    return string.length > (length ? length : process.stdout.columns)
        ? string.substring(0, length) + "..."
        : string;
};

export const getExtensionUrl = (
    ext: Extension,
    registry: ExtensionRegistry
): Promise<https.RequestOptions> => {
    return new Promise((resolve, reject) => {
        if (registry == "official") {
            const uri = `https://${ext.publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${ext.publisher}/extension/${ext.id}/${ext.version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage`;
            return resolve({
                host: new URL(uri).host,
                port: new URL(uri).port,
                protocol: new URL(uri).protocol,
                path: new URL(uri).pathname,
                timeout: 1000000,
            });
        }
        const extInfoUrl = `https://open-vsx.org/api/redhat/vscode-yaml/1.5.1`;
        const req = https.get(extInfoUrl, (res) => {
            let body = "";
            res.on("data", (chunk) => (body += chunk));
            res.on("end", () => {
                const json: OpenVSXAPIResponse = JSON.parse(body);
                if (json.files && json.files.download) {
                    return resolve({
                        host: new URL(json.files.download).host,
                        port: new URL(json.files.download).port,
                        protocol: new URL(json.files.download).protocol,
                        path: new URL(json.files.download).pathname,
                        timeout: 1000000,
                    });
                } else {
                    reject("No file found.");
                }
            });
        });
        req.on("error", (err) => reject(err.message));
    });
};

export const downloadExtension = (
    url: https.RequestOptions,
    target: fs.PathLike,
    mpb: MultiProgressBars,
    extensionId: string
): Promise<string> => {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(target);
        mpb.addTask(`Install ${extensionId}`, {
            type: "percentage",
            message: `Download ${extensionId}`,
            barTransformFn: chalk.blue,
            nameTransformFn: chalk.blue,
        });
        const req = https.get(url, (resp) => {
            mpb.incrementTask(`Install ${extensionId}`, {
                percentage: percentage(
                    0,
                    parseInt(resp.headers["content-length"] || "1000000000")
                ),
                message: `Download ${extensionId} (0 of ${parseInt(
                    resp.headers["content-length"] || "1000000000"
                )} bytes)`,
            });
            resp.on("data", (c) => {
                mpb.incrementTask(`Install ${extensionId}`, {
                    percentage: percentage(
                        noFraction(c.length / 2),
                        parseInt(resp.headers["content-length"] || "1000000000")
                    ),
                    message: `Download ${extensionId} (${
                        c.length
                    } of ${parseInt(
                        resp.headers["content-length"] || "1000000000"
                    )} bytes)`,
                });
            });
            resp.pipe(file);
            file.on("finish", () => {
                mpb.incrementTask(`Install ${extensionId}`, {
                    percentage: percentage(
                        noFraction(file.bytesWritten / 2),
                        file.bytesWritten
                    ),
                    message: `Download ${extensionId} (${file.bytesWritten} of ${file.bytesWritten} bytes)`,
                });
                return file.close(() => resolve("Completed."));
            });
        });
        req.on("error", (err) => {
            fs.unlinkSync(target);
            mpb.updateTask(`Install ${extensionId}`, {
                percentage: 0,
                message: "An error occured.",
            });
            return reject(err.message);
        });
    });
};

export const extractExtension = (
    sourceFile: fs.PathLike,
    target: fs.PathLike,
    mpb: MultiProgressBars,
    extensionId: string
): Promise<string> => {
    if (!fs.existsSync(target)) fs.mkdirSync(target);
    mpb.updateTask(`Install ${extensionId}`, {
        message: `Extract ${extensionId}`,
        barTransformFn: chalk.cyan,
        nameTransformFn: chalk.cyan,
    });
    return new Promise((resolve, reject) => {
        yauzl.open(sourceFile.toString(), { lazyEntries: true }, (err, zip) => {
            if (err) return reject(err);
            if (!zip) return reject("No zip");
            zip.readEntry();
            zip.on("entry", (e: yauzl.Entry) => {
                if (folderRegex.test(e.fileName)) {
                    if (
                        !fs.existsSync(path.join(target.toString(), e.fileName))
                    )
                        fs.mkdirSync(path.join(target.toString(), e.fileName)),
                            { recursive: true };
                    return zip.readEntry();
                } else {
                    mpb.incrementTask(`Install ${extensionId}`, {
                        percentage: percentage(1, zip.entryCount) / 2,
                        message: `Extract ${extensionId} (${zip.entriesRead} of ${zip.entryCount} files extracted)`,
                    });
                    const filename_ = e.fileName.split("/");
                    filename_.pop();
                    const filename = filename_.join("/");
                    if (!fs.existsSync(path.join(target.toString(), filename)))
                        fs.mkdirSync(path.join(target.toString(), filename), {
                            recursive: true,
                        });
                    zip.openReadStream(e, (err, readstream) => {
                        if (err) {
                            mpb.updateTask(`Install ${extensionId}`, {
                                percentage:
                                    50 +
                                    noFraction(
                                        percentage(
                                            zip.entriesRead,
                                            zip.entryCount
                                        ) / 2
                                    ),
                                message: "There was an error.",
                            });
                            return reject(err);
                        }
                        const writestream = fs.createWriteStream(
                            path.join(target.toString(), e.fileName)
                        );
                        if (!readstream) {
                            mpb.updateTask(`Install ${extensionId}`, {
                                percentage:
                                    50 +
                                    noFraction(
                                        percentage(
                                            zip.entriesRead,
                                            zip.entryCount
                                        ) / 2
                                    ),
                                message: "No read stream found.",
                            });
                            return reject("No read stream found.");
                        }
                        readstream.on("end", () => {
                            writestream.close();
                            if (zip.entriesRead == zip.entryCount) {
                                if (fs.existsSync(sourceFile))
                                    fs.rmSync(sourceFile);
                                mpb.done(`Install ${extensionId}`, {
                                    barTransformFn: chalk.ansi(90),
                                    nameTransformFn:
                                        chalk.strikethrough.ansi(90),
                                });
                                return resolve("Completed extraction.");
                            }
                            zip.readEntry();
                        });
                        readstream.pipe(writestream);
                    });
                }
            });
        });
    });
};

export const percentage = (value: number, total: number) => {
    return ((100 * value) / total) * 0.01;
};

export const noFraction = (val: number) => parseInt(val.toFixed(0));

export const randomColor = (): Chalk => {
    return colors[Math.floor(Math.random() * colors.length)];
};
