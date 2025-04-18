-- Minimal Lush Colorscheme
-- For use with Lush.nvim (https://github.com/rktjmp/lush.nvim)

-- Initialize lush
local lush = require('lush')
local hsl = lush.hsl

-- Define base colors
local black = hsl(0, 0, 10)
local dark_gray = hsl(0, 0, 20)
local gray = hsl(0, 0, 40)
local light_gray = hsl(0, 0, 65)
local white = hsl(0, 0, 90)

local blue = hsl(210, 70, 60)
local cyan = hsl(180, 70, 60)
local green = hsl(120, 60, 60)
local orange = hsl(30, 70, 60)
local purple = hsl(270, 60, 60)
local red = hsl(0, 70, 60)
local yellow = hsl(60, 70, 65)

-- Define the theme
local theme = lush(function()
  return {
    -- Basic UI elements
    Normal       { fg = white, bg = black }, -- Normal text
    NormalFloat  { fg = white, bg = dark_gray }, -- Normal text in floating windows
    NormalNC     { Normal }, -- Normal text in non-current windows

    Cursor       { fg = black, bg = white }, -- Cursor
    CursorLine   { bg = dark_gray.lighten(5) }, -- Screen-line at the cursor
    CursorLineNr { fg = yellow, bold = true }, -- Line number at the cursor
    LineNr       { fg = gray }, -- Line number
    SignColumn   { LineNr }, -- Column where signs are displayed
    VertSplit    { fg = dark_gray.lighten(10) }, -- Vertical split between windows

    Pmenu        { bg = dark_gray, fg = light_gray }, -- Popup menu
    PmenuSel     { bg = gray, fg = white }, -- Selected item in popup menu
    PmenuSbar    { bg = dark_gray }, -- Popup menu scrollbar
    PmenuThumb   { bg = gray }, -- Popup menu thumb

    StatusLine   { bg = dark_gray, fg = white }, -- Status line of current window
    StatusLineNC { bg = dark_gray, fg = gray }, -- Status lines of non-current windows

    Search       { bg = blue.darken(30), fg = white }, -- Search highlighting
    IncSearch    { bg = orange, fg = black }, -- 'Incremental' search highlighting

    Visual       { bg = blue.darken(40) }, -- Visual mode selection
    VisualNOS    { Visual }, -- Visual mode selection when vim is "Not Owning the Selection"

    Folded       { fg = light_gray, bg = dark_gray.darken(10) }, -- Folded lines
    FoldColumn   { LineNr }, -- Column where folds are displayed

    -- Syntax highlighting
    Comment      { fg = gray, italic = true }, -- Comments

    Constant     { fg = purple }, -- Constants
    String       { fg = green }, -- String literals
    Character    { String }, -- 'c' in '\n'
    Number       { fg = orange }, -- Numbers
    Boolean      { Constant }, -- Booleans
    Float        { Number }, -- Floating point numbers

    Identifier   { fg = white }, -- Variable names
    Function     { fg = blue }, -- Function names

    Statement    { fg = purple }, -- Statements
    Conditional  { Statement }, -- if, then, else, etc.
    Repeat       { Statement }, -- for, while, etc.
    Label        { Statement }, -- case, default, etc.
    Operator     { fg = light_gray }, -- +, -, *, etc.
    Keyword      { Statement }, -- Keywords
    Exception    { Statement }, -- try, catch, etc.

    PreProc      { fg = cyan }, -- Generic preprocessor
    Include      { PreProc }, -- #include
    Define       { PreProc }, -- #define
    Macro        { PreProc }, -- Same as Define
    PreCondit    { PreProc }, -- Preprocessor #if, #else, etc.

    Type         { fg = yellow }, -- Type names
    StorageClass { Type }, -- static, register, etc.
    Structure    { Type }, -- struct, union, etc.
    Typedef      { Type }, -- A typedef

    Special      { fg = orange }, -- Special characters
    SpecialChar  { Special }, -- Special character in a string
    Tag          { Special }, -- You can use CTRL-] on this
    Delimiter    { fg = light_gray }, -- '(', ')', etc.
    SpecialComment { fg = gray, bold = true }, -- Special comments
    Debug        { Special }, -- Debugging statements

    Underlined   { fg = blue, underline = true }, -- Text that stands out, HTML links
    Bold         { bold = true },
    Italic       { italic = true },

    Error        { fg = red, bold = true }, -- Error messages
    Todo         { fg = black, bg = yellow, bold = true }, -- TODO, FIXME, etc.

    -- LSP highlights
    DiagnosticError       { fg = red }, -- Error diagnostics
    DiagnosticWarn        { fg = yellow }, -- Warning diagnostics
    DiagnosticInfo        { fg = blue }, -- Information diagnostics
    DiagnosticHint        { fg = cyan }, -- Hint diagnostics

    DiagnosticUnderlineError { sp = red, undercurl = true }, -- Underlined errors
    DiagnosticUnderlineWarn  { sp = yellow, undercurl = true }, -- Underlined warnings
    DiagnosticUnderlineInfo  { sp = blue, undercurl = true }, -- Underlined info
    DiagnosticUnderlineHint  { sp = cyan, undercurl = true }, -- Underlined hints

    -- Diff highlighting
    DiffAdd      { fg = black, bg = green.darken(50) }, -- Added lines
    DiffChange   { fg = black, bg = blue.darken(50) }, -- Changed lines
    DiffDelete   { fg = black, bg = red.darken(50) }, -- Deleted lines
    DiffText     { fg = black, bg = yellow.darken(50) }, -- Changed text within a changed line

    -- Spelling
    SpellBad     { sp = red, undercurl = true }, -- Words not recognized
    SpellCap     { sp = yellow, undercurl = true }, -- Words that should start with capital
    SpellLocal   { sp = cyan, undercurl = true }, -- Words for another region
    SpellRare    { sp = purple, undercurl = true }, -- Rare words
  }
end)

-- Return our theme
return theme
