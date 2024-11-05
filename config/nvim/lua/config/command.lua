local command = vim.api.nvim_create_user_command
my = require("my")
command("LazySync", "Lazy sync", {})

command("CdCurrent", "cd %:p:h", {})
command("Cn", function()
  my.echo_and_yank(vim.fn.expand("%:t"))
end, {})
command("Cfp", function()
  my.echo_and_yank(vim.fn.expand("%:p"))
end, {})
command("Crp", function()
  my.echo_and_yank(vim.fn.expand("%"))
end, {})
command("Cdp", function()
  my.echo_and_yank(my.get_root_dir())
end, {})
command("Cdn", function()
  my.echo_and_yank(string.gsub(my.get_root_dir(), ".*/", ""))
end, {})

command("TCurrent", function()
  local path = vim.fn.expand("%:p")
  if vim.fn.filereadable(path) == 1 then
    local dir_path = vim.fn.expand("%:p:h")

    vim.cmd("new")
    vim.fn.termopen("bash", { cwd = dir_path })
  else
    print("Current buffer is not file!!")
  end
end, {})

command("RTP", function()
  print(vim.fn.substitute(vim.opt.runtimepath._value, ",", "\n", "g"))
end, {})
command("ReflectVimrc", "source $MYVIMRC", {})

command("Atcoder", function()
  vim.cmd("only")
  vim.cmd("only")
end, {})
