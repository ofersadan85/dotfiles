--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.10-dev') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`, `rg`
  local required_tools = { 'git', 'unzip', 'rg' }
  local optional_tools = { 'make' }
  
  -- On Windows, check for common alternatives and provide installation guidance
  local is_windows = vim.fn.has 'win32' == 1
  
  for _, exe in ipairs(required_tools) do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      if is_windows then
        vim.health.warn(string.format("Could not find executable: '%s'", exe))
        if exe == 'git' then
          vim.health.info('Install with: winget install Git.Git')
        elseif exe == 'rg' then
          vim.health.info('Install with: winget install BurntSushi.ripgrep.MSVC')
        elseif exe == 'unzip' then
          vim.health.info('Install with: winget install 7zip.7zip (includes unzip compatibility)')
        end
      else
        vim.health.warn(string.format("Could not find executable: '%s'", exe))
      end
    end
  end
  
  -- Check optional tools
  for _, exe in ipairs(optional_tools) do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      if is_windows then
        vim.health.info(string.format("Optional tool not found: '%s'", exe))
        if exe == 'make' then
          vim.health.info('Install with: winget install GnuWin32.Make or use Visual Studio Build Tools')
        end
      else
        vim.health.warn(string.format("Could not find executable: '%s'", exe))
      end
    end
  end

  return true
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))
    
    -- Windows-specific information
    if vim.fn.has 'win32' == 1 then
      vim.health.info('Running on Windows')
      
      -- Check for Windows-specific tools
      local win_tools = {
        { 'pwsh', 'PowerShell Core - Install with: winget install Microsoft.PowerShell' },
        { 'powershell', 'Windows PowerShell - Usually pre-installed' },
        { 'win32yank.exe', 'Clipboard utility - Install with: winget install equalsraf.win32yank' },
        { 'cmake', 'Build system - Install with: winget install Kitware.CMake' },
      }
      
      for _, tool in ipairs(win_tools) do
        if vim.fn.executable(tool[1]) == 1 then
          vim.health.ok(string.format("Found: %s", tool[1]))
        else
          vim.health.info(string.format("Optional: %s", tool[2]))
        end
      end
    end

    check_version()
    check_external_reqs()
  end,
}
