/*
 * Copyright (c) 2002-2017 "Neo Technology,"
 * Network Engine for Objects in Lund AB [http://neotechnology.com]
 *
 * This file is part of Neo4j.
 *
 * Neo4j is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.neo4j.doc.build.docbook

import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction
import com.icl.saxon.StyleSheet

class XsltTask extends DefaultTask {

    Map<String, String> options = [:]
    Map<String, String> parameters

    Map<String, String> argumentMappings = [
            uriResolver:            '-r',
            sourceSaxParser:        '-x',
            stylesheetSaxParser:    '-y',
            verbose:                '-t',
            outFile:                '-o',
    ]

    void input(Object input) {
        this.options.input = input
    }

    void outFile(Object file) {
        this.options.outFile = file
    }

    void stylesheet(Object stylesheet) {
        this.options.stylesheet = stylesheet
    }

    // -r
    void uriResolver(Object uriResolver) {
        this.options.uriResolver = uriResolver
    }

    // -x
    void sourceSaxParser(Object parser) {
        this.options.sourceSaxParser = parser
    }

    // -y
    void stylesheetSaxParser(Object parser) {
        this.options.stylesheetSaxParser =  parser
    }

    // -t
    void verbose(Object onoff) {
        this.options.verbose = onoff
    }

    // -u
    void usingUrls(boolean onoff) {
        this.options.usingUrls = onoff
    }

    // Register custom URLStreamHandler to resolve `classpath:` URLs.
    void usingClasspathUrls(boolean onoff) {
        this.options.usingClasspathUrls = onoff
    }

    void parameters(Map<String, String> parameters) {
        this.parameters = parameters
    }

    List<String> makeArguments() {
        List<String> args = []
        if (this.options.verbose) {
            args.add("-t")
        }
        this.options.findAll {
            !['input', 'outFile', 'stylesheet', 'usingUrls', 'usingClasspathUrls', 'verbose'].contains(it.key)
        }.each { o ->
            logger.quiet("[*] adding arg:    key: ${o.key}    value: ${o.value}")
            args.add(argumentMappings[o.key])
            args.add(o.value)
        }
        if (this.options.usingUrls) {
            args.add("-u")
        }
        if (this.options.outFile) {
            args.add("-o")
            args.add(this.options.outFile)
        }

        if (this.options.usingClasspathUrls) {
            TaskUtil.registerStreamHandlerFactory()
        }

        args.add(this.options.input)
//        args.add(this.options.output)
        args.add(this.options.stylesheet)
        args.addAll(makeParameters())
        args
    }

    List<String> makeParameters() {
        this.parameters.collect { k, v ->
            "$k=$v"
        }
    }

    @TaskAction
    def run() {
        logger.quiet("[+] task start")
        logger.quiet("[++] args:")
        makeArguments().each {
            logger.quiet("[-]  $it")
        }
        StyleSheet.main(makeArguments() as String[])
        logger.quiet("[+] task stop")
    }

}
