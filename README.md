# dotfiles

This is my new dotfiles setup and infrastructure.
The only requirement is to have a bash installation that is relatively recent, although I have no idea what you can away with.
However, you will need to install [Homebrew](https://brew.sh/) on macOS as the package manager.
In principle these should work on ArchLinux (I personally use it there), Ubuntu, and macOS (I plan to use it there).
The quick way to get started is to use the provided setup script that you can call using `./setup init_system`. 
This should setup your machine appropriately.
There are more options available to discover them you can run `./setup usage`.

## Writing Packages

The system is organized in terms of "packages", which are simply sub-directories containing that contain a setup script.
Each package must contains all the configuration data it needs within this sub-directory, usually this is consists of some configuration files to be symlinked into specific locations.

**TODO talk about host package lists.**

The `setup` script contained within the package directory must contain some specifically named functions that perform the necessary steps for installation, configuration, and removal.

To assist you in writing these scripts the following variables are defined as well as the usual bash environment variables:
- `package_dir` is the absolute path to the package sub-directory.

- `data_dir` is the directory to use for packages or things that need to store data in a unspecified location.
The default value of this `~/data`.
 

The functions needed for installation and configuration are in this order:

1. `_${package_name}_pre_install` if this exists, performs host agnostic configuration before the dependency installation phase. Usually this creates directory structures and such.

2. `_${package_name}_pre_install_${hosttype}` if it exists, performs host specific configuration before dependency installation.

3. `_${package_name}_install_deps_${hosttype}` if it exists, installs needed dependencies for a specific host.
This normally involves invoking the host systems package manager.
Alternatively, if the dependency installation procedure is completely host agnostic, you can instead define `_${package_name}_install_deps`.

4. `_${package_name}_link_files_${hosttype}` if it exists, is responsible for symlinking files into their destinations.
If this does not need to be host specific you can use the `_${package_name}_link_files` form, but one of the two forms must be defined.

5. `_${package_name}_post_install_${hosttype}` if it exists, performs any host specific actions needed after the files have been symlinked.
This is rarely needed.

6. `_${package_name}_post_install` if it exists, performs any host agnostic actions needed after the files have been symlinked.
This is rarely needed.

**TODO describe clean up sequence similarly.**

## Roadmap

The following features are still planned:

- Add testing facilities to the setup script beyond just building the images and the CI pipeline.
Ideally each package could provide a `_${package_name}_test_${hosttype}` function to validate that everything is as it should.

- Better support for macOS in CI and local testing by creating a new user with a separate chroot for testing.

- Improve documentation
