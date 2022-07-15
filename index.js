const core = require('@actions/core');
const exec = require('child_process');
const os = require('os');

try {
    console.log("VCPKG automated configurator\n");

    core.setCommandEcho(true);

    const packages = core.getMultilineInput('out-package-id');
    if (packages.length < 1) {
        core.setFailed("You must specify package IDs.");
        return;
    }

    console.log("Downloading VCPKG...")
    const process = exec.exec("git clone 'https://github.com/microsoft/vcpkg'");
    if (process.exitCode != 0) {
        core.setFailed("Error while downloading VCPKG.");
    }

    const platform = os.platform();

    console.log("Installing VCPKG...");
    if (platform == 'win32') {
        const process = exec.exec("vcpkg/bootstrap_vcpkg.bat");
        if (process.exitCode != 0) {
            core.setFailed("Error while installing VCPKG.");
        }
    }
    else {
        const process = exec.exec("vcpkg/bootstrap_vcpkg.sh");
        if (process.exitCode != 0) {
            core.setFailed("Error while installing VCPKG.");
        }
    }

    packages.forEach(name =>
    {
        console.log("vcpkg - installing " + name + "...");
        if (platform == 'win32') {
            const process = exec.exec("vcpkg/vcpkg.exe install " + name);
            if (process.exitCode != 0) {
                core.setFailed("Error while installing VCPKG.");
            }
        }
        else {
            const process = exec.exec("vcpkg/vcpkg install " + name);
            if (process.exitCode != 0) {
                core.setFailed("Error while installing VCPKG.");
            }
        }
    });
}
catch (error) {
    core.setFailed(error.message);
}