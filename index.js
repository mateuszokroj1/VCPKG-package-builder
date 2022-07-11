const core = require('@actions/core');
const github = require('@actions/github');
const exec = require('child_process');

try {
    console.log("VCPKG automated configurator\n");
    const token = core.getInput("GITHUB_TOKEN");

    const packages = core.getMultilineInput('out-package-id');
    if (packages.length < 1) {
        core.setFailed("You must specify package IDs.");
        return;
    }

    const process = exec.execSync("git clone 'https://github.com/microsoft/vcpkg'");
    

    //const api = github.getOctokit(token);
    //const { context } = github;
    //context.
}
catch (error) {
    core.setFailed(error.message);
}