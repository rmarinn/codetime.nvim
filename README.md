# codetime.nvim
A coding time tracker plugin for neovim

## Commands
`:CodeTime` prints total coding time today

## Setup

### using lazy.nvim

place this in your plugin spec
```
return {
    {
        "rmarinn/codetime.nvim"
        opts = {} -- this is required so that setup() would be called
    }
}
```

### when not using lazy.nvim
just make sure you call `codetime.setup()` after requiring it or else it won't work
