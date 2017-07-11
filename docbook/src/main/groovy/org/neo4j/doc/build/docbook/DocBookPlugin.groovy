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

import org.gradle.api.Plugin
import org.gradle.api.Project
import org.neo4j.doc.build.xslt.XsltTask

import java.util.stream.IntStream

class DocBookPlugin implements Plugin<Project> {

    @Override
    void apply(Project project) {
        project.task('html', type: XsltTask) {

            def stylesheetName = "xsl/chunk-from-toc/xhtml/chunktoc.xsl"
            def url = getClass().getClassLoader().getResource(stylesheetName)
            stylesheet url

            sourceSaxParser "org.apache.xml.resolver.tools.ResolvingXMLReader"
            stylesheetSaxParser "org.apache.xml.resolver.tools.ResolvingXMLReader"
            uriResolver "org.apache.xml.resolver.tools.CatalogResolver"

            usingUrls true
            usingClasspathUrls true
            if (project.hasProperty('traceDocbook')) { verbose true }
            usingXIncludes true
        }

        project.task('preprocess', type: XsltTask) {

            def stylesheetName = "xsl/custom/neo/preprocess.xsl"
            def url = getClass().getClassLoader().getResource(stylesheetName)
            stylesheet url

            sourceSaxParser "org.apache.xml.resolver.tools.ResolvingXMLReader"
            stylesheetSaxParser "org.apache.xml.resolver.tools.ResolvingXMLReader"
            uriResolver "org.apache.xml.resolver.tools.CatalogResolver"

            usingUrls true
            usingClasspathUrls true
            if (hasProperty('traceDocbook')) { verbose true }

        }

    }



}
