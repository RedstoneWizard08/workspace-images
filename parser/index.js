const path = require("path");
const fs = require("fs");
const dfp = require("docker-file-parser");
const uuid = require("uuid");
const execa = require("execa");
const { spawn } = require('child_process')

const p = path.join(process.cwd(), "Dockerfile");
const c = fs.readFileSync(p, { encoding: "utf-8" }).toString();

const e = dfp.parse(c, { includeComments: true });

const cname = `a_dockerfile_testing_${uuid.v4().replace(/\-/gm, "_")}`;
let i = `run -it --rm --name ${cname} `;

e.forEach((c) => {
    if(c.name == "ENV" && c.raw) i += `-e ${c.raw.replace("ENV ", "")} `;
});

for(let j = 0; j < e.length; j++) {
    if(e[j].name == "FROM" && e[j].raw) {
        i += `${e[j].raw.replace("FROM ", "")}`;
        break;
    }
}

console.log(`Running as container ${cname}.`);
console.log(i);
const s = spawn("docker", i.split(" "), { stdio: "inherit" });
s.on("close", (c) => console.log(`Process exited with code ${c}.`));