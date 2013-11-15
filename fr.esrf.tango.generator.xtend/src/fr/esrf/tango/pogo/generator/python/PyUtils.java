//+======================================================================
//
// Project:   Tango
//
// Description:  source code for Tango code generator.
//
// $Author: verdier $
//
// Copyright (C) :  2004,2005,2006,2007,2008,2009,2009,2010,2011,2012,2013
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
package fr.esrf.tango.pogo.generator.python;

import fr.esrf.tango.pogo.pogoDsl.Command;

public class PyUtils {
	
	//===========================================================
	/**
	 * Returns the method execution name for specified command (special case for State and Status) 
	 * @param command the specified command
	 * @return  the method execution name for specified command
	 */
	//===========================================================
	String methodName(Command command) {
		if (command.getName().equals("State"))
			return "dev_state";
		else
		if (command.getName().equals("Status"))
			return "dev_status";
		else
			return command.getName();
	}
	//===========================================================
	/**
	 * Returns the method execution name for specified command (special case for State and Status) 
	 * @param command the specified command
	 * @return  the method execution name for specified command
	 */
	//===========================================================
	String returnMethodCode(Command command) {
		
		if (command.getName().equals("State")) {
			return	"if argout != PyTango.DevState.ALARM:\n" +
					"    PyTango.Device_4Impl.dev_state(self)\n" +
					"return self.get_state()";
		}
		else
		if (command.getName().equals("Status")) {
			return	"self.set_status(self.argout)\n" +
					"self.__status = PyTango.Device_4Impl.dev_status(self)\n" +
					"return self.__status";
		}
		else {
		    if (!command.getArgout().getType().toString().contains("Void"))
		    	return "return argout";
			return "";
		}
	}
}