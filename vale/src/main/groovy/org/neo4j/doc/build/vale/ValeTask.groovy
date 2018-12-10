package org.neo4j.doc.build.vale

import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction

class ValeTask extends DefaultTask {

    def setup = new ValeSetup()
    def config = project.extensions.vale
    def valeWorkingDir = "${project.buildDir}/vale"

    def valeExecutable = "vale"

    @TaskAction
    def validate() {
        if (hasAsciidoctor()) {
            prepare()
            def result = project.exec {
                executable valeExecutable
                workingDir valeWorkingDir
                standardOutput = new ByteArrayOutputStream()
                errorOutput = new ByteArrayOutputStream()
                ext.output = {
                    return standardOutput.toString()
                }
                ext.error = {
                    return errorOutput.toString()
                }
                ignoreExitValue true
                args([
                        "--glob=${config.glob}",
                        "--no-wrap",
                        "--sort",
                        config.inputPath,
                ])
                if (config.verbose) {
                    println "[vale] executable: $executable"
                    println "[vale] workingDir: $workingDir"
                    println "[vale] args: $args"
                }
            }
            processResult(ext.output())
        } else {
            logger.warn("Could not find `asciidoctor`. Aborting vale lint task.")
        }
    }

    def prepare() {
        if (!setup.executableExists(valeExecutable)) {
            def f = setup.doSetup(valeWorkingDir)
            def tree
            if (f.name.endsWith('.zip')) {
                tree = project.zipTree(f)
            } else if (f.name.endsWith('.tar.gz')) {
                tree = project.tarTree(f)
            } else {
                throw new IllegalArgumentException("File must be .zip or .tar.gz [${f.name}]")
            }
            project.copy {
                from tree
                into valeWorkingDir
            }
            valeExecutable = "./$valeExecutable"
        }
        copyConfig()
        if (!config.logDir.empty) {
            def l = project.file("${config.logDir}/${new Date().format('yyyy-MM-dd_HH-mm-ss')}_vale.log")
            if (!l.exists()) {
                l.createNewFile()
            }
            if (l.canWrite()) {
                OutputStream log = new FileOutputStream(l)
                getLogging().addStandardOutputListener(log)
                getLogging().addStandardErrorListener(log)
            }
        }
    }

    private void copyConfig() {
        def fromObj = defaultValeConfig()
        project.copy {
            from(fromObj) {
                include 'vale_styles/**'
                include '.vale'
            }
            into valeWorkingDir
        }
    }

    def defaultValeConfig = {
        URL url = getClass().getClassLoader().getResource(".vale")
        String path = url.path
        if (path.contains(".jar!")) {
            path = path.substring("file:".length(), path.lastIndexOf("!"))
            project.zipTree(path)
        } else {
            path = path.substring(0, path.lastIndexOf("/"))
            path
        }

    }

    private void processResult(String output) {
        output.split(System.lineSeparator()).each {
            def parts = it.split(/\s{2,}/)
            if (parts.length > 1) {
                log(it, parts[1])
            } else {
                log(it, "quiet")
            }
        }
    }

    void log(String message, String severity) {
        switch (severity) {
            case "warning":
                logger.warn(message)
                break
            case "error":
                logger.error(message)
                break
            default:
                logger.quiet(message)
        }
    }

    private boolean hasAsciidoctor() {
        return setup.executableExists("asciidoctor")
    }

}
