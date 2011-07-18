## Gosu Modes

This is just a collection of various convenient Emacs modes for working with Gosu, a statically typed language for the JVM created by Guidewire Software (http://www.gosu-lang.org).

There are three separate modes here: `gosu-mode.el`, `inferior-gosu-mode.el` and `gosu-program-mode.el`. Generally, all three are mutually independent except for a single key binding defined in `gosu-mode.el` that launches a buffer in `inferior-gosu-mode`.

#### Gosu Mode

This is a simple mode, created using `define-generic-mode` that provides some basic indenting and highlighting for Gosu. It is the same mode as on the Gosu website ([here](http://www.gosu-lang.org/downloads/gosu-emacs.el)), with a few additions and enhancements:

 * More keywords - I just added any missing keywords I came upon while editing.
 * Constant face - true, false, null and this are now highlighted in the same face as numbers.
 * Arrows - Now all instances of "->" are turned into arrows, allowing for pretty map literals.
 * Inferior Gosu mode - `C-c C-l` now launches an inferior Gosu process. For this to work, `inferior-gosu-mode.el` has to be loaded as well.

#### Inferior Gosu Mode

This is just a simple comint-based mode for interacting with an inferior Gosu process. It does not do anything special--it just sets the buffer's name, the Gosu executable and provides a command to run it. For `C-c C-l` to work in `gosu-mode`, this has to be loaded.

#### Gosu Program Mode

This is, perhaps, the least Gosu-specific mode of the three. In fact, it does not have any Gosu-specific code _at all_. However, I've only used it for Gosu, and by default it comes configured for use with [Ronin](http://ronin-web.org), so a Gosu mode it shall remain.

To use this minor mode, open up a shell (`M-x shell`) then go to the directory where your program located, optionally changing the active profile or using `M-x gosu-set-program` and `M-x gosu-set-test-command` to configure which commands will be run by the various key bindings.

The commands provided by this minor mode are:

 * `C-c C-j` clears the buffer then launches the program.
 * `C-c C-t` clears the buffer then launches the tests.
 * `C-c C-l` clears the buffer and presents a (shell) prompt.
 * `C-c C-;` changes the active profile.

##### Profiles

This mode is trivially configurable for different program and test commands through the use of "profiles". A profile is just the set of commands that will be run by `C-c C-j` and `C-c C-t`. You can add a profile using the `gosu-add-profile` function in your `.emacs` file. By default, there is one example profile for use with a Ronin server (the commands to run and test are, respectively, "vark server" and "vark test").
