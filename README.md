# http_archive rule that fetches ony the archive for your OS

```python
git_repository(
    name = "com_github_jemdiggity_rules_os_dependent_http_archive",
    remote = "https://github.com/jemdiggity/rules_os_dependent_http_archive.git",
    commit = "",
)
load("@com_github_jemdiggity_rules_os_dependent_http_archive//os_dependent_http_archive.bzl", "os_dependent_http_archive")

# Example to download gcc-arm-none-eabi for currrent OS.
os_dependent_http_archive(
  name = 'toolchain_gcc_arm_none',
  build_file = 'compilers/gcc_arm_none.BUILD',
  urls_linux = ['https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2'],
  sha256_linux = "a397c49bdd0cf17a38a494cb691baf68b8dcffa4d4c06561ef3d71b2ab4c92a1",
  urls_darwin = ['https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-mac.tar.bz2'],
  sha256_darwin = "5656cdec40f99d5c054a85bbc694276e1c4a1488cdacbbc448bc6acd3bbe070d",
  strip_prefix = 'gcc-arm-none-eabi-5_4-2016q3',
)
```