package org.neo4j.doc.build.vale

import org.gradle.api.Project
import org.gradle.api.Plugin

class ValePlugin implements Plugin<Project> {

    void apply(Project target) {
        target.extensions.create('vale', ValePluginExtension).inputPath = target.projectDir
        target.task('vale', type: ValeTask)
    }

}
