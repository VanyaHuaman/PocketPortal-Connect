ObjC.import("Foundation");

function readUtf8(path) {
  const value = $.NSString.stringWithContentsOfFileEncodingError(
    path,
    $.NSUTF8StringEncoding,
    null
  );
  if (!value) {
    throw new Error("Unable to read release metadata.");
  }
  return ObjC.unwrap(value);
}

function run(argv) {
  if (argv.length !== 1) {
    throw new Error("Expected a GitHub release metadata file.");
  }
  const release = JSON.parse(readUtf8(argv[0]));
  const tag = String(release.tag_name || "");
  const version = tag.startsWith("v") ? tag.slice(1) : tag;
  if (!/^[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$/.test(version)) {
    throw new Error("The latest release has an invalid version.");
  }

  const archiveName = `pocketportal-connect-${version}-macos.zip`;
  const checksumName = `${archiveName}.sha256`;
  const assets = Array.isArray(release.assets) ? release.assets : [];
  const archive = assets.find((asset) => asset.name === archiveName);
  const checksum = assets.find((asset) => asset.name === checksumName);
  if (!archive || !checksum) {
    throw new Error("The latest release is missing macOS assets.");
  }

  return [
    version,
    String(archive.browser_download_url),
    String(checksum.browser_download_url),
  ].join("\n");
}
