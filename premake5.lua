workspace "SlithEngine"
	architecture "x86"
	startproject "Sandbox"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

group "Dependencies"
	include "SlithEngine/vendor/dearIMGUI"
	include "SlithEngine/vendor/GLAD"
group ""


project "SlithEngine"
	location "SlithEngine"
	kind "SharedLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "se_pch.h"
	pchsource "SlithEngine/src/se_pch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/src/**.c",
		"shaders/**.frag",
		"shaders/**.vert"
	}

	includedirs
	{
		"%{prj.name}/vendor/spdlog/include",
		"%{prj.name}/includes",
		"%{prj.name}/vendor/dearIMGUI",
		"%{prj.name}/vendor/GLAD/include"
	}

	libdirs
	{
		"%{prj.name}/libs"
	}

	links
	{
		"assimp-vc140-mt.lib",
		"assimpd.lib",
		"glfw3.lib",
		"opengl32.lib",
		"ImGui",
		"Glad"
	}


	filter "system:windows"
		systemversion "latest"

		defines
		{
			"SE_PLATFORM_WINDOWS",
			"SE_BUILD_DLL"

		}

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}

	filter "configurations:Debug"
		defines "SE_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "SE_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "SE_DIST"
		runtime "Release"
		optimize "on"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"SlithEngine/vendor/spdlog/include",
		"SlithEngine/src",
		"SlithEngine/includes",
		"SlithEngine/vendor/dearIMGUI",
		"SlithEngine/vendor/GLAD/include"
	}

	libdirs
	{
		"SlithEngine/libs"
	}

	links
	{
		"SlithEngine",
		"assimpd.lib",
		"glfw3.lib",
		"opengl32.lib"
	}

	filter "system:windows"
		systemversion "latest"

		defines
		{
			"SE_PLATFORM_WINDOWS",
		}

	filter "configurations:Debug"
		defines "SE_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "SE_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "SE_DIST"
		runtime "Release"
		optimize "on"
