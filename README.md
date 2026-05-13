# mvc2stereo
`mvc2stereo` is a macOS command-line tool for converting MVC stereoscopic 3D video into practical modern stereo formats.
It was developed by **Alaric Hamacher** for real-world stereoscopic 3D production, restoration, archiving, and post-production workflows.
The tool is designed for MVC-based 3D video sources that are difficult to use directly in current editing software.

---

## Table of Contents

- [Purpose](#purpose)
- [Main Applications](#main-applications)
- [Supported Output Modes](#supported-output-modes)
  - [Side-by-Side ProRes](#side-by-side-prores)
  - [Dual ProRes](#dual-prores)
  - [MV-HEVC](#mv-hevc)
- [Supported Input Formats](#supported-input-formats)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Basic Usage](#basic-usage)
- [Batch Conversion Script](#batch-conversion-script)
- [Audio Options](#audio-options)
- [Keeping Temporary Files](#keeping-temporary-files)
- [Example Workflows](#example-workflows)
  - [Convert AVCHD 3D Footage for Editing](#convert-avchd-3d-footage-for-editing)
  - [Create Left and Right Eye Master Files](#create-left-and-right-eye-master-files)
  - [Create an MV-HEVC Stereo Movie](#create-an-mv-hevc-stereo-movie)
  - [Test Only the Beginning of a File](#test-only-the-beginning-of-a-file)
- [DaVinci Resolve Workflow](#davinci-resolve-workflow)
- [JVC MVC MP4 / MOV Support](#jvc-mvc-mp4--mov-support)
- [Why This Tool Exists](#why-this-tool-exists)
- [Workshop and Festival Use](#workshop-and-festival-use)
- [Technical Notes](#technical-notes)
- [Current Limitations](#current-limitations)
- [Author](#author)
- [Third-Party Code Notice](#third-party-code-notice)
- [License](#license)

---
---
## Purpose
Many older stereoscopic 3D cameras recorded video using **MVC** — **Multiview Video Coding**.
MVC is an extension of H.264/AVC. It stores:
- one full **base view**
- one dependent **second view**
This format was used in:
- AVCHD 3D `.MTS` / `.M2TS` recordings
- Blu-ray 3D video streams
- some JVC MVC `.MP4` / `.MOV` camera files
Today, many applications can open these files but only show the base 2D view. The second stereo view is often ignored.
`mvc2stereo` converts both views into usable stereo video formats.
---
## Main Applications
`mvc2stereo` can be used for:
- stereoscopic 3D post-production
- editing MVC 3D footage in DaVinci Resolve
- restoring older 3D camera recordings
- archiving stereoscopic video material
- creating side-by-side ProRes files
- creating separate left/right ProRes masters
- creating MV-HEVC stereo QuickTime movies
- preparing stereo material for headset workflows
- stereoscopic projection and screening
- research and education in 3D filmmaking
---
## Supported Output Modes
### Side-by-Side ProRes
Creates one ProRes movie with left and right eye images arranged side-by-side.
```bash
mvc2stereo input.MTS --mode sbs-prores
```
Useful for:
- quick review
- editing
- 3D monitoring
- projection workflows
- conversion to other stereo formats
---
### Dual ProRes
Creates separate left-eye and right-eye ProRes movie files.
```bash
mvc2stereo input.MTS --mode dual-prores
```
Useful for:
- high-quality stereo post-production
- color correction
- compositing
- stereo alignment
- archival mastering
---
### MV-HEVC
Creates a multilayer HEVC QuickTime movie.
```bash
mvc2stereo input.MTS --mode mv-hevc
```
Useful for:
- Apple spatial video experiments
- headset playback workflows
- modern stereo delivery testing
Compatibility depends on the playback or editing software.
---
## Supported Input Formats
Current input support:
- `.MTS`
- `.M2TS`
- `.264`
- `.h264`
- `.avc`
- experimental JVC MVC `.MP4`
- experimental JVC MVC `.MOV`
The `.MTS` and `.M2TS` processing pipeline is implemented natively in Swift and does **not** require Python.
---
## Installation
Install with Homebrew:
```bash
brew tap stereo3d/tools
brew install stereo3d/tools/mvc2stereo
```
Check the installation:
```bash
mvc2stereo --help
```
---
## Dependencies
Homebrew installs the required FFmpeg dependency automatically.
`mvc2stereo` currently uses:
- `ffprobe` for reading video information
- `ffmpeg` for audio muxing
- `ffmpeg` for experimental MP4/MOV MVC extraction
Python is **not required** for normal `.MTS` / `.M2TS` MVC processing.
---
## Basic Usage
Convert an MVC `.MTS` file to side-by-side ProRes:
```bash
mvc2stereo input.MTS --mode sbs-prores
```
Convert only the first 100 stereo frames:
```bash
mvc2stereo input.MTS --mode sbs-prores --max-frames 100
```
Create separate left and right ProRes files:
```bash
mvc2stereo input.MTS --mode dual-prores
```
Create MV-HEVC:
```bash
mvc2stereo input.MTS --mode mv-hevc
```
---

## Batch Conversion Script

A simple batch script is provided for converting all supported MVC files inside one folder.

The script uses the Homebrew-installed `mvc2stereo` binary:

```bash
TOOL="mvc2stereo"
```

This means `mvc2stereo` must already be installed and available in the terminal:

```bash
brew tap stereo3d/tools
brew install stereo3d/tools/mvc2stereo
```

Make the script executable:

```bash
chmod +x batch_mvc2stereo.sh
```

Run it on a folder:

```bash
./batch_mvc2stereo.sh /path/to/folder
```

If no folder is given, the current folder is used:

```bash
./batch_mvc2stereo.sh
```

The script currently scans for the following file extensions, in upper and lower case:

```text
.MTS
.mts
.M2TS
.m2ts
.MP4
.mp4
.MOV
.mov
```

The default output mode is:

```bash
MODE="mv-hevc"
```

You can edit the script and change this line to one of:

```bash
MODE="dual-prores"
MODE="sbs-prores"
MODE="mv-hevc"
```

The script automatically skips files when the expected output already exists.

Expected output names:

```text
dual-prores  → input_L.mov and input_R.mov
sbs-prores   → input_SBS.mov
mv-hevc      → input_MVHEVC.mov
```

A log file is created automatically:

```text
batch_YYYYMMDD_HHMMSS.log
```

Example:

```bash
./batch_mvc2stereo.sh /Volumes/media/3D/my_folder
```

---
## Audio Options
By default, audio is preserved.
Use PCM audio:
```bash
mvc2stereo input.MTS --mode sbs-prores --audio pcm
```
Use AAC audio:
```bash
mvc2stereo input.MTS --mode sbs-prores --audio aac
```
Disable audio:
```bash
mvc2stereo input.MTS --mode sbs-prores --audio none
```
---
## Keeping Temporary Files
For debugging or inspection, keep intermediate files:
```bash
mvc2stereo input.MTS --mode sbs-prores --keep-temp
```
This can be useful for checking:
- extracted base view stream
- extracted dependent MVC stream
- rebuilt MVC elementary stream
- decoder input
---
## Example Workflows
### Convert AVCHD 3D Footage for Editing
```bash
mvc2stereo 00093.MTS --mode sbs-prores
```
This creates a side-by-side ProRes file that can be imported into editing software.
---
### Create Left and Right Eye Master Files
```bash
mvc2stereo 00093.MTS --mode dual-prores
```
This creates two separate ProRes files, one for each eye.
---
### Create an MV-HEVC Stereo Movie
```bash
mvc2stereo 00093.MTS --mode mv-hevc
```
This creates a multilayer HEVC QuickTime movie for modern spatial video experiments.
---
### Test Only the Beginning of a File
```bash
mvc2stereo 00093.MTS --mode sbs-prores --max-frames 100
```
This is useful for checking whether a file decodes correctly before processing the full video.
---
## DaVinci Resolve Workflow
`mvc2stereo` outputs files that can be used directly in DaVinci Resolve workflows.
Some MVC source files are interlaced. In this case, DaVinci Resolve may not always interpret the field order correctly automatically.
DaVinci Resolve has an excellent deinterlacer using the Neural Engine. For best results:
1. Import the converted file into DaVinci Resolve.
2. Right-click the clip in the Media Pool.
3. Choose **Clip Attributes**.
4. Set the correct interlaced field order, for example:
   - upper field first
   - lower field first
   - progressive
5. Enable the appropriate deinterlacing settings in the project or clip settings if needed.
For side-by-side stereo files, DaVinci Resolve can also identify the clip as stereoscopic 3D material:
1. Right-click the side-by-side clip.
2. Open **Clip Attributes**.
3. Set the stereoscopic 3D format to **Side-by-Side**.
4. Use DaVinci Resolve’s stereo 3D tools for editing, alignment, convergence, and output.
MV-HEVC clips are usually recognized directly as stereo/spatial video by compatible software. However, depending on the original source, interlaced settings may still need to be checked manually.
Recommended workflow:
```text
MVC source file
→ mvc2stereo conversion
→ import into DaVinci Resolve
→ check Clip Attributes
→ set interlaced/progressive interpretation if needed
→ set stereoscopic format if using side-by-side ProRes
→ edit, color grade, and export
```
---
## JVC MVC MP4 / MOV Support
Some JVC 3D cameras recorded MVC streams inside MP4 or MOV containers.
`mvc2stereo` includes experimental support for these files.
The program extracts MVC-related header information from the MP4 container and rebuilds a JM-compatible MVC stream.
This preparation step can take time, especially with large files.
Example:
```bash
mvc2stereo input.MP4 --mode sbs-prores
```
For some JVC files, interlaced `50i` sources may be reported as `50 fps` by `ffprobe`.
`mvc2stereo` compensates for this by writing interlaced MP4/MOV outputs at half the reported frame rate when appropriate.
Example:
```text
FPS: 50/1
Field order: tt
Output FPS: 25/1
```
---
## Why This Tool Exists
A large amount of stereoscopic 3D material was recorded in MVC-based formats that are no longer well supported by current software.
Many modern applications can open the files, but only show the base 2D image. The second eye is often unavailable.
`mvc2stereo` was created to make this material usable again.
The goal is not only playback, but also:
- restoration
- post-production
- education
- stereoscopic research
- preservation of older 3D camera material
- conversion to modern immersive media formats
---
## Workshop and Festival Use

`mvc2stereo` has been used in practical stereoscopic 3D education and production workflows, including the **New Media Workshop / 3D Masterclass** connected to the **Busan International Short Film Festival**.

More information:

[3D Masterclass in Busan](https://lab3d.kw.ac.kr/3d-masterclass-in-busan/)

The tool supports this type of educational workflow by making MVC 3D camera footage easier to convert, review, edit, and project in modern post-production environments.
---
## Technical Notes
`mvc2stereo` uses the JM reference MVC decoder internally for MVC decoding.
For `.MTS` and `.M2TS` files, transport stream demuxing and MVC access-unit merging are implemented in Swift.
For JVC `.MP4` / `.MOV` MVC files, the tool currently still relies on FFmpeg for video extraction before rebuilding the MVC stream.
---
## Current Limitations
- JVC MP4/MOV support is experimental.
- Some damaged or incomplete MP4/MOV files may not fully extract.
- MV-HEVC compatibility depends on the target playback application.
- Field-order handling depends on the output format and editing application.
- The current binary release is for macOS Apple Silicon.
---
## Author
`mvc2stereo` was written by **Alaric Hamacher**.
The tool was developed from practical stereoscopic 3D production, post-production, and archival needs.
---
## Third-Party Code Notice

`mvc2stereo` includes modified code derived from the JM H.264/AVC reference decoder.

The JM reference software includes ISO/IEC and ITU copyright and warranty notices. These notices are included in [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

The JM notice grants a free license to the software module and modifications, but it does not grant patent rights. Users intending to use the software in products should review the applicable patent and licensing situation.
---
## License
Copyright © Alaric Hamacher.
License information will be added with the public source-code release.
