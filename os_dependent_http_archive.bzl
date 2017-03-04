# Copyright 2016 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Modified by https://github.com/jemdiggity

def _cpu_value(repository_ctx):
  """Returns the name of the host operating system.
  Args:
    repository_ctx: The repository context.
  Returns:
    A string containing the name of the host operating system.
  """
  os_name = repository_ctx.os.name.lower()
  if os_name.startswith("mac os"):
    return "Darwin"
  if os_name.find("windows") != -1:
    return "Windows"
  result = repository_ctx.execute(["uname", "-s"])
  return result.stdout.strip()

def _os_dependent_http_archive(ctx):
  """Implementation of the http_archive rule."""
  if ctx.attr.build_file and ctx.attr.build_file_content:
    ctx.fail("Only one of build_file and build_file_content can be provided.")

  cpu_value = _cpu_value(ctx)
  if cpu_value == "Darwin":
    ctx.download_and_extract(ctx.attr.urls_darwin, "", ctx.attr.sha256_darwin, ctx.attr.type,
      ctx.attr.strip_prefix)
  elif cpu_value == "Linux":
    ctx.download_and_extract(ctx.attr.urls_linux, "", ctx.attr.sha256_linux, ctx.attr.type,
      ctx.attr.strip_prefix)
  elif cpu_value == "Windows":
    ctx.download_and_extract(ctx.attr.urls_windows, "", ctx.attr.sha256_windows, ctx.attr.type,
      ctx.attr.strip_prefix)
  else:
    fail("%s is not supported" % cpu_value)

  ctx.file("WORKSPACE", "workspace(name = \"{name}\")\n".format(name=ctx.name))
  if ctx.attr.build_file:
    print("ctx.attr.build_file %s" % str(ctx.attr.build_file))
    ctx.symlink(ctx.attr.build_file, "BUILD")
  else:
    ctx.file("BUILD", ctx.attr.build_file_content)

_os_dependent_http_archive_attrs = {
  "strip_prefix": attr.string(),
  "type": attr.string(),
  "build_file": attr.label(),
  "build_file_content": attr.string(),
  "urls_linux": attr.string_list(),
  "urls_darwin": attr.string_list(),
  "urls_windows": attr.string_list(),
  "sha256_linux": attr.string(),
  "sha256_darwin": attr.string(),
  "sha256_windows": attr.string(),
}

os_dependent_http_archive = repository_rule(
  implementation = _os_dependent_http_archive,
  attrs = _os_dependent_http_archive_attrs,
)


