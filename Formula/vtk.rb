class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  revision 10
  head "https://github.com/Kitware/VTK.git"

  stable do
    url "https://www.vtk.org/files/release/9.0/VTK-9.0.1.tar.gz"
    sha256 "1b39a5e191c282861e7af4101eaa8585969a2de05f5646c9199a161213a622c7"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fontconfig"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "netcdf"
  depends_on "pyqt"
  depends_on "python@3.8"
  depends_on "qt"

  def install
    pyver = Language::Python.major_minor_version "python3"
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DVTK_USE_COCOA:BOOL=ON
      -DVTK_MODULE_ENABLE_VTK_InfovisBoost:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_RenderingFreeTypeFontConfig:STRING=YES
      -DVTK_MODULE_USE_EXTERNAL_VTK_expat:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_jpeg:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_netcdf:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_png:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_tiff:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=ON 
      -DVTK_WRAP_PYTHON:BOOL=ON
      -DVTK_PYTHON_VERSION=3
      -DPython3_EXECUTABLE:PATH=#{Formula["python@3.8"].opt_bin}/python3
      -DVTK_GROUP_ENABLE_Qt:STRING=YES
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    vtk_include = Dir[opt_include/"vtk-*"].first
    major, minor = vtk_include.match(/.*-(.*)$/)[1].split(".")

    (testpath/"version.cpp").write <<~EOS
      #include <vtkVersion.h>
      #include <assert.h>
      int main(int, char *[]) {
        assert (vtkVersion::GetVTKMajorVersion()==#{major});
        assert (vtkVersion::GetVTKMinorVersion()==#{minor});
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "-std=c++11", "version.cpp", "-I#{vtk_include}"
    system "./a.out"
    system "#{bin}/vtkpython", "-c", "exit()"
  end
end
