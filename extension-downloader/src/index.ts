import chalk from "chalk";
import { program } from "commander";
import fs from "fs";
import { MultiProgressBars } from "multi-progress-bars";
import path from "path";
import { Extension, ExtensionConfiguration } from "./types";
import {
    downloadExtension,
    extractExtension,
    getExtensionUrl,
    percentage,
} from "./util";

async function main() {
    const defaultExtensionsFilePath = path.join(
        __dirname,
        "defaultextensions.json"
    );

    const argv = (
        await program
            .option("-v, --version", "Shows the version.", false)
            .option(
                "-c, --cache",
                "If selected, this will not delete the downloaded extensions when run.",
                false
            )
            .option(
                "-f, --file",
                "The JSON file containing the extensions to install.",
                defaultExtensionsFilePath
            )
            .option(
                "-r, --registry",
                "The registry to use. Will override the registry in the extensions JSON. Allowed values: official, openvsx",
                "official"
            )
            .parseAsync()
    ).opts();

    const extensionsFilePath = path.resolve(
        argv.file ? argv.file : defaultExtensionsFilePath
    );
    const extensionsFile = fs
        .readFileSync(extensionsFilePath, { encoding: "utf-8" })
        .toString();
    const extensionsJSON: ExtensionConfiguration = JSON.parse(extensionsFile);
    const extensions: Extension[] = extensionsJSON.extensions;

    const extFolder = path.join(process.cwd(), "extensions");
    if (fs.existsSync(extFolder) && !argv.cache)
        fs.rmSync(extFolder, { recursive: true });
    fs.mkdirSync(extFolder);
    const mpb = new MultiProgressBars({
        initMessage: " $ VS Code Extension Download and Extraction ",
        anchor: "top",
        persist: true,
        border: true,
        progressWidth: 50,
        numCrawlers: 100,
        spinnerFPS: 60,
    });
    mpb.addTask("Total Extensions Installed", {
        type: "percentage",
        barTransformFn: chalk.yellow,
        nameTransformFn: chalk.yellow,
    });
    let done = 0;
    for (let i = 0; i < extensions.length; i++) {
        const ext = extensions[i];
        const outFile = path.join(
            extFolder,
            `${ext.publisher}-${ext.id}-${ext.version}.vsix.zip`
        );
        const outFolder = path.join(
            extFolder,
            `${ext.publisher}-${ext.id}-${ext.version}`
        );
        const url = await getExtensionUrl(
            ext,
            argv.registry
                ? argv.registry
                : extensionsJSON.registry
                ? extensionsJSON.registry
                : "official"
        );
        downloadExtension(url, outFile, mpb, `${ext.publisher}.${ext.id}`).then(
            () => {
                extractExtension(
                    outFile,
                    outFolder,
                    mpb,
                    `${ext.publisher}.${ext.id}`
                ).then(() => {
                    done++;
                    mpb.incrementTask("Total Extensions Installed", {
                        percentage: percentage(1, extensions.length),
                    });
                });
            }
        );
    }
    await mpb.promise;
    if (done == extensions.length) mpb.done("Total Extensions Installed");
    if (done == extensions.length) mpb.close();
    if (done == extensions.length) console.log("\n");
    if (done == extensions.length) process.exit(0);
}

main();
