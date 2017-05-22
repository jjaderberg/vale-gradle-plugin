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
        prepare()
        project.exec {
            executable 'vale'
            workingDir valeWorkingDir
            args([
                    "--glob=${config.glob}",
                    config.failBuild ? "" : "--no-exit",
                    config.inputPath,
            ])
            if (config.verbose) {
                println "[vale] executable: $executable"
                println "[vale] workingDir: $workingDir"
                println "[vale] args: $args"
            }
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

}
