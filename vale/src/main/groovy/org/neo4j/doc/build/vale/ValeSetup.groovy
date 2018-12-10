package org.neo4j.doc.build.vale

import java.nio.file.Files
import java.nio.file.Paths
import java.util.regex.Pattern

class ValeSetup {

    String OSX = "https://github.com/ValeLint/vale/releases/download/v0.6.2/vale_macOS_64-bit.tar.gz"
    String WIN = "https://github.com/ValeLint/vale/releases/download/v0.6.2/vale_Windows_64-bit.zip"
    String NIX = "https://github.com/ValeLint/vale/releases/download/v0.6.2/vale_Linux_64-bit.tar.gz"

    boolean executableExists(String name) {
        def path = System.env.PATH
        boolean existsInPath = "$path".split(Pattern.quote(File.pathSeparator)).collect {
            Paths.get(it)
        }.any { dir ->
            Files.exists(dir.resolve(name))
        }
        return existsInPath
    }

    private String urlByOs() {
        def os = System.getProperty('os.name').toLowerCase()
        if (os.contains("windows")) {
            WIN
        } else if (os.contains("os x")) {
            OSX
        } else if (os.contains("linux")) {
            NIX
        } else {
            throw new UnsupportedOperationException("Unkown OS: $os")
        }
    }

    private void download(String url, File targetFile) {
        if (!targetFile.getParentFile().exists()) {
            Files.createDirectories(Paths.get(targetFile.getParent()))
        }
        new URL(url).withInputStream{ i -> targetFile.withOutputStream{ it << i }}
    }

    File doSetup(String targetDir) {
        def url = urlByOs()
        def targetFile = url.split('/')[-1]
        def f = Paths.get(targetDir).resolve(targetFile).toFile()
        if (!f.exists()) {
            download(url, f)
        }
        f
    }

}
