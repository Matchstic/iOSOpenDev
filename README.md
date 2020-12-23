## iOSOpenDev—iOS Open Development
- Copyright (c) 2012-2013 Spencer W.S. James (Kokoabim).
- Copyright (c) 2019- Matt Clarke (Matchstic).

iOSOpenDev allows you to develop tweaks and other jailbroken utilities using Xcode.

### Dependencies

- [`theos`](https://github.com/theos/theos): to handle stuff like pre-processing Logos syntax.
- [`simject`](https://github.com/angelXwind/simject): to run tweaks in the iOS Simulator

### Installation

1. Clone this repository (requires usage of `git submodule`) to `/opt`
   The end path for e.g. `install.sh` should be `/opt/iOSOpenDev/install.sh`
2. `cd` to it
3. Run `git submodule init && git submodule update`
4. Run `./install.sh --theos=/opt/theos`

### `./install.sh` options

| Option                        |  Result                                                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------- |
| `--theos=`                | Sets the path where `theos` is installed. Default: `/opt/theos`                    |
| `--no-simject`        | Skips `simject` as part of the installation procedure                                     |
| `--patch-simject`  | (Re-)patches available iOS simulators after installing a new one                    |
| `--patch-xcode`      | (Re-)patches Xcode for open development (required after Xcode updates)   |

### Handling Xcode updates

Whenever you update Xcode, the new SDK needs to be patched, and the old ones to be moved into place. Simply run the following to do this: 

```
./install.sh --patch-xcode
```

You may also need to patch any new iOS simulators. Use the following to do this:

```
./install.sh --patch-simject
```

### Usage

- To create a new project, use Xcode's `File -> New -> Project` option. Then, scroll down to `Templates` in the `iOS` tab.
- To compile a project, use Xcode's `Product -> Build`. Executables built can be found via the auto-generated `LatestBuild` symlink.
- To build a `.deb`, use Xcode's `Product -> Build For -> Profiling`. Built packages are found in `Packages`.
- To change version numbers of a built package, modify `PackageVersion.plist`.

### Known issues

When you create a new project, you'll need to adjust the deployment target to `<= 10.3` if you're targeting `armv7`. This is to avoid Xcode complaining that iOS 12 and higher don't support 32-bit targets.

### iOS Simulator

Right now, running tweaks in the iOS Simulator isn't super smooth. You need to do the following:

1. Change the value of the `SIMJECT` flag in your project settings to `YES`.
2. Add the following to the top of your `.xm` file:
```
%config(generator=internal);
```
3. Start an iOS Simulator (`Xcode -> Open Developer Tool -> Simulator`) and wait for it to finish starting up
4. Copy the `.plist` sitting alongside your `dylib` to `/opt/simject` (temporary workaround, needed only the first time)
5. Compile your tweak again targeting an iOS Simulator

### Authors

* Follow [@kokoabim](https://twitter.com/kokoabim)
* Follow [@_Matchstic](https://twitter.com/_Matchstic)
