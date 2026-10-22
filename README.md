# Zip Release [![License](https://img.shields.io/github/license/TheDoctor0/zip-release)](https://github.com/TheDoctor0/zip-release/blob/master/LICENSE)
GitHub action that can be used to create release zip archive.

## Usage
An example workflow config:
```
name: Create Archive
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Archive Release
      uses: thedoctor0/zip-release@master
      with:
        filename: 'release.zip'
        exclusions: '*.git* /*node_modules/* .editorconfig'
```

## Arguments
| Argument | Description | Default |
|---|---|---|
| filename | Filename for archive | release.zip |
| path | Base path for archive files | . |
| directory | Working directory before zipping | . |
| exclusions | List of excluded files/directories | |

## Privacy

This Action contacts Chainguard's licensing server to verify authorization. Connection metadata (IP address, GitHub repository identifier, timestamp, and any metadata encoded in the auth token) is transmitted to Chainguard, Inc. even if authorization is denied in accordance with our [Privacy Notice](https://www.chainguard.dev/legal/privacy-notice)
