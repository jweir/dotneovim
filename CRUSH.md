# CRUSH.md - Neovim Configuration

## Test Commands
- **Run single test**: Use neotest with `<leader>tr` (run nearest test) or `<leader>tf` (run file tests)
- **Test command**: `bin/test` (configured in neotest-minitest adapter)
- **No build/lint commands** - This is a pure Neovim configuration

## Code Style Guidelines

### Lua Conventions
- **Indentation**: 2 spaces (no tabs)
- **Variable naming**: snake_case (`lazypath`, `culsp_group`)
- **Function naming**: camelCase (`openAmsTestFailuresQuickFix`, `toggleScheme`)
- **String literals**: Prefer single quotes `'` for simple strings, double quotes `"` when needed
- **Imports**: Use `require()` at point of use, not at top of file
- **Comments**: Use `--` for line comments, `--[[ ]]` for blocks

### File Structure
- **Main config**: Single `init.lua` file (monolithic approach)
- **Plugin management**: lazy.nvim with table-based configuration
- **LSP setup**: Capabilities-based configuration with format-on-save
- **Keymaps**: Use `vim.keymap.set()` with descriptive opts tables

### Ruby/Rails Focus
- **Primary language**: Ruby with Rails support via vim-rails
- **Test framework**: Minitest via neotest-minitest adapter
- **LSP**: Configured for Ruby development with formatting on save
- **File navigation**: NERDTree + fzf for file exploration

### Error Handling
- Check for plugin availability before setup
- Use timeout_ms for LSP operations (1000ms for formatting)
- Graceful fallbacks for missing dependencies