
 project "in_openmpt"
  uuid "D75AEB78-5537-49BD-9085-F92DEEFA84E8"
  language "C++"
  location ( "../../build/" .. mpt_projectpathname )
  vpaths { ["*"] = "../../libopenmpt/" }
  mpt_projectname = "in_openmpt"
  dofile "../../build/premake/premake-defaults-DLL.lua"
  dofile "../../build/premake/premake-defaults.lua"
  warnings "Extra"
  local extincludedirs = {
   "../..",
   "../../include",
  }
	filter { "action:vs*" }
		includedirs ( extincludedirs )
	filter { "not action:vs*" }
		sysincludedirs ( extincludedirs )
	filter {}
  includedirs {
   "../..",
   "$(IntDir)/svn_version",
   "../../build/svn_version",
  }
  files {
   "../../libopenmpt/in_openmpt.cpp",
   "../../libopenmpt/libopenmpt_plugin_settings.hpp",
   "../../libopenmpt/libopenmpt_plugin_gui.hpp",
   "../../libopenmpt/libopenmpt_plugin_gui.cpp",
   "../../libopenmpt/libopenmpt_plugin_gui.rc",
   "../../libopenmpt/resource.h",
  }
	
	filter { "action:vs*", "kind:SharedLib or ConsoleApp or WindowedApp" }
		resdefines {
			"MPT_BUILD_VER_FILENAME=\"" .. mpt_projectname .. ".dll\"",
			"MPT_BUILD_VER_FILEDESC=\"" .. mpt_projectname .. "\"",
		}
	filter { "action:vs*", "kind:SharedLib or ConsoleApp or WindowedApp" }
		resincludedirs {
			"$(IntDir)/svn_version",
			"../../build/svn_version",
			"$(ProjDir)/../../build/svn_version",
		}
		files {
			"../../libopenmpt/libopenmpt_version.rc",
		}
	filter { "action:vs*", "kind:SharedLib" }
		resdefines { "MPT_BUILD_VER_DLL" }
	filter { "action:vs*", "kind:ConsoleApp or WindowedApp" }
		resdefines { "MPT_BUILD_VER_EXE" }
	filter {}

  characterset "Unicode"
  flags { "MFC" }
	-- work-around https://developercommunity.visualstudio.com/t/link-errors-when-building-mfc-application-with-cla/1617786
	if _OPTIONS["clang"] then
		filter {}
		filter { "configurations:Debug" }
			if true then -- _AFX_NO_MFC_CONTROLS_IN_DIALOGS
				ignoredefaultlibraries { "afxnmcdd.lib"}
				links { "afxnmcdd.lib" }
			end
			ignoredefaultlibraries { "uafxcwd.lib", "libcmtd.lib" }
			links { "uafxcwd.lib", "libcmtd.lib" }
		filter { "configurations:DebugShared" }
			ignoredefaultlibraries { "mfc140ud.lib", "msvcrtd.lib" }
			links { "mfc140ud.lib", "msvcrtd.lib" }
		filter { "configurations:Checked" }
			if true then -- _AFX_NO_MFC_CONTROLS_IN_DIALOGS
				ignoredefaultlibraries { "afxnmcd.lib" }
				links { "afxnmcd.lib" }
			end
			ignoredefaultlibraries { "uafxcw.lib", "libcmt.lib" }
			links { "uafxcw.lib", "libcmt.lib" }
		filter { "configurations:CheckedShared" }
			ignoredefaultlibraries { "mfc140u.lib", "msvcrt.lib" }
			links { "mfc140u.lib", "msvcrt.lib" }
		filter { "configurations:Release" }
			if true then -- _AFX_NO_MFC_CONTROLS_IN_DIALOGS
				ignoredefaultlibraries { "afxnmcd.lib" }
				links { "afxnmcd.lib" }
			end
			ignoredefaultlibraries { "uafxcw.lib", "libcmt.lib" }
			links { "uafxcw.lib", "libcmt.lib" }
		filter { "configurations:ReleaseShared" }
			ignoredefaultlibraries { "mfc140u.lib", "msvcrt.lib" }
			links { "mfc140u.lib", "msvcrt.lib" }
		filter {}
	end
  links { "libopenmpt", "zlib", "vorbis", "ogg", "mpg123" }
  filter {}
  prebuildcommands { "..\\..\\build\\svn_version\\update_svn_version_vs_premake.cmd $(IntDir)" }
