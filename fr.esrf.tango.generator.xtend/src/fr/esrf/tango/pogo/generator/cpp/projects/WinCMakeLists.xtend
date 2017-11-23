//+======================================================================
//
// Project:   Tango
//
// Description:  source code for Tango code generator.
//
// $Author: verdier $
//
// Copyright (C) :  2004,2005,2006,2007,2008,2009,2009,2010,2011,2012,2013,2014
//					European Synchrotron Radiation Facility
//                  BP 220, Grenoble 38043
//                  FRANCE
//
// This file is part of Tango.
//
// Tango is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Tango is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Tango.  If not, see <http://www.gnu.org/licenses/>.
//
// $Revision: $
// $Date:  $
//
// $HeadURL: $
//
//-======================================================================

package fr.esrf.tango.pogo.generator.cpp.projects

import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import fr.esrf.tango.pogo.generator.cpp.utils.Headers

//======================================================
// Define Windiws CMakeLists file to be generated
//======================================================
class WinCMakeLists {
	
	@Inject	extension Headers
	@Inject	extension MakefileUtils
	
	//======================================================
	// Define Windows CMakeLists code to be generated
	//======================================================
	def generateWinCMakeLists (PogoDeviceClass cls) '''
		«cls.name.makefileHeader(true)»

		cmake_minimum_required (VERSION 2.8)
		set(CMAKE_SKIP_RPATH true)
		
		# Windows cmakelists

		«cls.makeEnv(true)»
		#
		# Project definitions
		#
		project(«cls.name»)

		#
		# optional compiler flags
		#
		set(CXXFLAGS_USER -g)
		

		#
		# Get global information
		#
		include(CmakeTangoWin.cmake)
		
		«cls.cmakeClassParameters»
		«cls.cmakeInheritanceClassParameters»
		
		
		#
		# User additional include, link folders/libraries and source files
		#
		set(USER_INCL_DIR )
		set(USER_LIB_DIR )
		set(USER_LIBS )
		set(USER_SRC_FILES )

		#
		# Set global info and include directories
		#
		set(ALL_CLASS_INCLUDE  ${«cls.upperClassName»_INCLUDE} «cls.cmakeInheritanceFileList("_INCLUDE")» ${USER_INCL_DIR})
		set(SERVER_SRC ${«cls.upperClassName»_SRC} «cls.cmakeInheritanceFileList("_SRC")» ${USER_SRC_FILES} ClassFactory.cpp main.cpp)
		include_directories(${ALL_CLASS_INCLUDE}  ${USER_INCL_DIR} ${TANGO_INCLUDES})
		link_directories(${TANGO_LNK_DIR})

		#
		# Device Server generation
		#
		set(SERVER_NAME «cls.name»)
		
		if (CMAKE_BUILD_TYPE STREQUAL "Debug")
		add_executable(«cls.name»_dyn_d ${SERVER_SRC})
		target_link_libraries(«cls.name»_dyn_d PUBLIC ${TANGO_DYN_LIBS_D} ${WIN_LIBS} ${ZMQ_LIB_DYN_D})
		install(TARGETS «cls.name»_dyn_d 
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION bin
			ARCHIVE DESTINATION bin)
		set_property(TARGET «cls.name»_dyn_d PROPERTY COMPILE_DEFINITIONS "LOG4TANGO_HAS_DLL;TANGO_HAS_DLL;")
		set_property(TARGET  «cls.name»_dyn_d PROPERTY LINK_FLAGS "/force:multiple")
		add_compile_options(/MTd)
		add_executable(«cls.name»_d ${SERVER_SRC})
		target_link_libraries(«cls.name»_d PUBLIC ${TANGO_STA_LIBS_D} ${WIN_LIBS} ${ZMQ_LIB_STA_D})
		target_compile_options(«cls.name»_d PUBLIC "/MTd")
		install(TARGETS «cls.name»_d 
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION bin
			ARCHIVE DESTINATION bin)

		set_property(TARGET «cls.name»_d PROPERTY COMPILE_DEFINITIONS "_WINSTATIC;")
		set_property(TARGET «cls.name»_d PROPERTY LINK_FLAGS "/force:multiple")
		else()
		add_executable(«cls.name»_dyn ${SERVER_SRC})
		target_link_libraries(«cls.name»_dyn PUBLIC ${TANGO_DYN_LIBS} ${WIN_LIBS} ${ZMQ_LIB_DYN})
		install(TARGETS «cls.name»_dyn 
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION bin
			ARCHIVE DESTINATION bin)
		set_property(TARGET «cls.name»_dyn PROPERTY COMPILE_DEFINITIONS "LOG4TANGO_HAS_DLL;TANGO_HAS_DLL;")
		set_property(TARGET  «cls.name»_dyn PROPERTY LINK_FLAGS "/force:multiple")
		add_compile_options(/MT)
		add_executable(«cls.name» ${SERVER_SRC})
		target_link_libraries(«cls.name» PUBLIC ${TANGO_STA_LIBS} ${WIN_LIBS} ${ZMQ_LIB_STA})
		target_compile_options(«cls.name» PUBLIC "/MT")
		install(TARGETS «cls.name» 
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION bin
			ARCHIVE DESTINATION bin)

		set_property(TARGET «cls.name» PROPERTY COMPILE_DEFINITIONS "_WINSTATIC;")
		set_property(TARGET «cls.name» PROPERTY LINK_FLAGS "/force:multiple")
		endif()
	'''
//		«cls.makefileIncludes»

	//======================================================
	// Define Linux miscellaneous code to be generated
	//======================================================
	def addMiscellaneousDefinitions (String project) '''
	'''
	
	//======================================================
	// Defaut cmake file to build against Tango
	//======================================================
	def generateCMakeWinConf () '''
		cmake_minimum_required(VERSION 3.0.2)
		set(CMP0048 NEW)

		# definitions and compile options
		add_definitions(-DWIN32)
		
		if (CMAKE_BUILD_TYPE STREQUAL "Debug")
		add_definitions(-DDEBUG)
		else()
		add_definitions(-DNDEBUG)
		endif()
		if(CMAKE_CL_64)
		add_definitions(-D_64BITS)
		if(MSVC14)
		add_definitions(-D_TIMERS_T_)
		endif(MSVC14)
		else(CMAKE_CL_64)
		add_definitions(-DJPG_USE_ASM)
		endif(CMAKE_CL_64)
		# include directories
		set(TANGO_INCLUDES "$ENV{TANGO_ROOT}/include")
		# link directories
		set(TANGO_LNK_DIR "$ENV{TANGO_ROOT}/bin;$ENV{TANGO_ROOT}/lib")
		# link files

		set(TANGO_STA_LIBS "$ENV{TANGO_ROOT}/lib/libtango.lib;$ENV{TANGO_ROOT}/lib/omniORB4.lib;$ENV{TANGO_ROOT}/lib/omniDynamic4.lib;$ENV{TANGO_ROOT}/lib/COS4.lib;$ENV{TANGO_ROOT}/lib/omnithread.lib;$ENV{TANGO_ROOT}/bin/msvcstub.lib;$ENV{TANGO_ROOT}/lib/pthreadVC2-s.lib")
		set(TANGO_DYN_LIBS "$ENV{TANGO_ROOT}/lib/tango.lib;$ENV{TANGO_ROOT}/bin/omniORB4_rt.lib;$ENV{TANGO_ROOT}/bin/omniDynamic4_rt.lib;$ENV{TANGO_ROOT}/bin/COS4_rt.lib;$ENV{TANGO_ROOT}/bin/omnithread_rt.lib;$ENV{TANGO_ROOT}/bin/msvcstub.lib;$ENV{TANGO_ROOT}/lib/pthreadVC2.lib")
		set(TANGO_STA_LIBS_D "$ENV{TANGO_ROOT}/lib/libtangod.lib;$ENV{TANGO_ROOT}/lib/omniORB4d.lib;$ENV{TANGO_ROOT}/lib/omniDynamic4d.lib;$ENV{TANGO_ROOT}/lib/COS4d.lib;$ENV{TANGO_ROOT}/lib/omnithreadd.lib;$ENV{TANGO_ROOT}/bin/msvcstubd.lib;$ENV{TANGO_ROOT}/lib/pthreadVC2-sd.lib")
		set(TANGO_DYN_LIBS_D "$ENV{TANGO_ROOT}/lib/tangod.lib;$ENV{TANGO_ROOT}/bin/omniORB4_rtd.lib;$ENV{TANGO_ROOT}/bin/omniDynamic4_rtd.lib;$ENV{TANGO_ROOT}/bin/COS4_rtd.lib;$ENV{TANGO_ROOT}/bin/omnithread_rtd.lib;$ENV{TANGO_ROOT}/bin/msvcstubd.lib;$ENV{TANGO_ROOT}/lib/pthreadVC2d.lib")
		set(WIN_LIBS ws2_32 mswsock advapi32 comctl32 odbc32)
		if(MSVC90)
		    set(ZMQ_LIB_STA $ENV{TANGO_ROOT}/lib/libzmq-v90-mt-s-4_0_5.lib)
		    set(ZMQ_LIB_DYN $ENV{TANGO_ROOT}/lib/libzmq-v90-mt-4_0_5.lib)
		    set(ZMQ_LIB_STA_D $ENV{TANGO_ROOT}/lib/libzmq-v90-mt-sgt-4_0_5.lib)
		    set(ZMQ_LIB_DYN_D $ENV{TANGO_ROOT}/lib/libzmq-v90-mt-gt-4_0_5.lib)
		elseif(MSVC10)
		    set(ZMQ_LIB_STA $ENV{TANGO_ROOT}/lib/libzmq-v100-mt-s-4_0_5.lib)
		    set(ZMQ_LIB_DYN $ENV{TANGO_ROOT}/lib/libzmq-v100-mt-4_0_5.lib)
		    set(ZMQ_LIB_STA_D $ENV{TANGO_ROOT}/lib/libzmq-v100-mt-sgd-4_0_5.lib)
		    set(ZMQ_LIB_DYN_D $ENV{TANGO_ROOT}/lib/libzmq-v100-mt-gd-4_0_5.lib)
		elseif(MSVC12)
		    set(ZMQ_LIB_STA $ENV{TANGO_ROOT}/lib/libzmq-v120-mt-s-4_0_5.lib)
		    set(ZMQ_LIB_DYN $ENV{TANGO_ROOT}/lib/libzmq-v120-mt-4_0_5.lib)
		    set(ZMQ_LIB_STA_D $ENV{TANGO_ROOT}/lib/libzmq-v120-mt-sgd-4_0_5.lib)
		    set(ZMQ_LIB_DYN_D $ENV{TANGO_ROOT}/lib/libzmq-v120-mt-gd-4_0_5.lib)
		elseif(MSVC14)
		    set(ZMQ_LIB_STA $ENV{TANGO_ROOT}/lib/libzmq-v140-mt-s-4_0_5.lib)
		    set(ZMQ_LIB_DYN $ENV{TANGO_ROOT}/lib/libzmq-v140-mt-4_0_5.lib)
		    set(ZMQ_LIB_STA_D $ENV{TANGO_ROOT}/lib/libzmq-v140-mt-sgd-4_0_5.lib)
		    set(ZMQ_LIB_DYN_D $ENV{TANGO_ROOT}/lib/libzmq-v140-mt-gd-4_0_5.lib)
		endif(MSVC90)

		#easy packagin with cpack and NSIS

		set (CPACK_PACKAGE_VENDOR "www.tango-controls.org")
		set (CPACK_PACKAGE_DESCRIPTION_SUMMARY "Tango - Connecting Things Together")
		set (CPACK_PACKAGE_VERSION "${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}")
		set (CPACK_PACKAGE_VERSION_MAJOR ${MAJOR_VERSION})
		set (CPACK_PACKAGE_VERSION_MINOR ${MINOR_VERSION})
		set (CPACK_PACKAGE_VERSION_PATCH ${PATCH_VERSION})

		set(CPACK_NSIS_HELP_LINK "http://www.tango-controls.org")
		set(CPACK_NSIS_URL_INFO_ABOUT "http://www.tango-controls.org")
		set(CPACK_NSIS_MODIFY_PATH ON)
		set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
		set(CPACK_NSIS_MENU_LINKS
		    "http://tango-controls.readthedocs.io/en/latest/" "Tango Doc")

		include(CPack)
	'''

}
