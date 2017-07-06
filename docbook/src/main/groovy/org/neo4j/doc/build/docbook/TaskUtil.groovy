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

import org.gradle.api.logging.Logger
import org.gradle.api.logging.Logging
import org.neo4j.protocol.classpath.ConfigurableStreamHandlerFactory
import org.neo4j.protocol.classpath.Handler

import java.lang.reflect.Field

class TaskUtil {

    private static final Logger logger = Logging.getLogger(XsltTask.class)

    static Boolean streamHandlerFactorySet = false
    static void registerStreamHandlerFactory() {
        logger.quiet("I was asked to register")
        if (streamHandlerFactorySet) {
            println "I will not register because I already did once"
            return
        }
        try {
            println "I will now register"
            Handler handler = new Handler()
            ConfigurableStreamHandlerFactory factory = new ConfigurableStreamHandlerFactory('classpath', handler)
            URL.setURLStreamHandlerFactory(factory)
            streamHandlerFactorySet = true
            println "I have now registered"
        } catch (Error maybeFactoryAlreadyDefined) {
            try {
                Object o = currentUrlStreamHandlerFactory()
                if (o instanceof ConfigurableStreamHandlerFactory) {
                    println "Factory is already set correctly"
                } else if(o.getClass().getCanonicalName().equals(ConfigurableStreamHandlerFactory.getCanonicalName())) {
                    println "I didn't set the factory, but it seems to be set correctly anyway"
                } else {
                    String type = o.getClass().getCanonicalName()
                    println "Someone else has set the factory to an object of type: $type"
                    throw (maybeFactoryAlreadyDefined)
                }
            } catch (NoSuchFieldException|IllegalAccessException e) {
                println "I was unable to inspect the current factory"
                throw (maybeFactoryAlreadyDefined)
            }
        }
    }

    private static Object currentUrlStreamHandlerFactory() {
        Field f = URL.getDeclaredField("factory")
        boolean wasAccessible = f.isAccessible()
        if (!wasAccessible) {
            f.setAccessible(true)
        }
        Object o = f.get(null)
        if (!wasAccessible) {
            f.setAccessible(false)
        }
        o
    }

}
