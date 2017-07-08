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
package org.neo4j.protocol.classpath

import org.apache.log4j.Logger
import org.junit.Test
import org.neo4j.doc.build.xslt.TaskUtil

class HandlerTest extends GroovyTestCase {

    Logger LOGGER = Logger.getLogger(HandlerTest.class)

    void setUp() {
        super.setUp()
        TaskUtil.registerStreamHandlerFactory()
    }

    @Test
    void testCanResolveClasspathUrls() {
        final String FILE_PATH = "xml/input1.xml"
        URL classpathUrl = new URL("classpath:$FILE_PATH")
        URL resourceUrl = getClass().getClassLoader().getResource(FILE_PATH)
        // The URL is resolved first when a connection is opened
        assertEquals("Resolved URLs should be equal", resourceUrl, classpathUrl.openConnection().url)
    }

    @Test
    void testCanHandleMultipleFactorySetsGracefully() {
        // Factory is set once in `setUp()`.
        // Setting it again would trigger a `java.lang.Error`, unless we handle it gracefully.
        TaskUtil.registerStreamHandlerFactory()
    }

}
