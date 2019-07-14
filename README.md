## iOSOpenDev—iOS Open Development
Copyright (c) 2012-2013 Spencer W.S. James (Kokoabim).

Copyright (c) 2019- Matt Clarke (Matchstic).

iOSOpenDev allows you to develop tweaks and other jailbroken utilities using Xcode.

### Dependencies

- [`theos`](https://github.com/theos/theos): to handle stuff like pre-processing Logos syntax.

### Installation

1. Clone this repository (requires usage of `git submodule`)
2. `cd` to it
3. Run `git submodule init && git submodule update`
4. Run `./install --theos=/opt/theos`

### `./install` options

| Option                        |  Result                                                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------- |
| `--theos=`                | Sets the path where `theos` is installed. Default: `/opt/theos`                    |
| `--no-simject`        | Skips `simject` as part of the installation procedure                                     |
| `--patch-simject`  | (Re-)patches available iOS simulators after installing a new one                    |
| `--patch-xcode`      | (Re-)patches Xcode for open development (required after Xcode updates)   |

### Handling Xcode updates

Whenever you update Xcode, the new SDK needs to be patched, and the old ones to be moved into place. Simply run the following to do this: 

```
./install --patch-xcode
```

You may also need to patch any new iOS simulators. Use the following to do this:

```
./install --patch-simject
```

### Usage

- To create a new project, use Xcode's `File -> New -> Project` option. Then, scroll down to `Templates` in the `iOS` tab.
- To compile a project, use Xcode's `Product -> Build`. Executables built can be found via the auto-generated `LatestBuild` symlink, with built packages under `Packages`.
- To change version numbers of a built package, modify `PackageVersion.plist`.

### Authors

* Follow [@kokoabim](https://twitter.com/kokoabim)
* Follow [@_Matchstic](https://twitter.com/_Matchstic)
