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

    static final xercesConfig = [
            "javax.xml.parsers.DocumentBuilderFactory": "org.apache.xerces.jaxp.DocumentBuilderFactoryImpl",
            "javax.xml.parsers.SAXParserFactory": "org.apache.xerces.jaxp.SAXParserFactoryImpl",
            "org.apache.xerces.xni.parser.XMLParserConfiguration": "org.apache.xerces.parsers.XIncludeParserConfiguration",
        ]

    private static final Logger logger = Logging.getLogger(TaskUtil.class)

    static Boolean streamHandlerFactorySet = false
    static void registerStreamHandlerFactory() {
        logger.debug("I was asked to register")
        if (streamHandlerFactorySet) {
            logger.debug("I will not register because I already did once")
            return
        }
        try {
            logger.debug("I will now register")
            Handler handler = new Handler()
            ConfigurableStreamHandlerFactory factory = new ConfigurableStreamHandlerFactory('classpath', handler)
            URL.setURLStreamHandlerFactory(factory)
            streamHandlerFactorySet = true
            logger.debug("I have now registered")
        } catch (Error maybeFactoryAlreadyDefined) {
            try {
                Object o = currentUrlStreamHandlerFactory()
                if (o instanceof ConfigurableStreamHandlerFactory) {
                    logger.debug("Factory is already set correctly")
                } else if(o.getClass().getCanonicalName().equals(ConfigurableStreamHandlerFactory.getCanonicalName())) {
                    logger.debug("I didn't set the factory, but it seems to be set correctly anyway")
                } else {
                    String type = o.getClass().getCanonicalName()
                    logger.debug("Someone else has set the factory to an object of type: $type")
                    throw (maybeFactoryAlreadyDefined)
                }
            } catch (NoSuchFieldException|IllegalAccessException e) {
                logger.debug("I was unable to inspect the current factory")
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

    static void configureXerces() {
        logger.debug("Configuring Xerces")
        xercesConfig.each { k, v ->
            System.setProperty(k, v)

        }
    }

    static void removeXercesConfig() {
        logger.debug("Removing Xerces configuration")
        xercesConfig.each { k, v ->
            System.clearProperty(k)
        }
    }

}
