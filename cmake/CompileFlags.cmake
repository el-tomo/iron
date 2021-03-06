if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)
  
    if(CMAKE_COMPILER_IS_GNUC)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe") # -m${ABI}
        if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL x86_64)
            if(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=nocona")
            endif()
        endif()
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -fbounds-check")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -funroll-all-loops")
        if(NOT WITH_PROFILING)
            if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL i686 OR CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL x86_64)
                set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -momit-leaf-frame-pointer")
            endif()
        else()
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")
        endif()
    endif()
  
    if(CMAKE_C_COMPILER_ID STREQUAL Intel)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -wall")#-m${ABI}
        if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL x86_64)
            if(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
                if(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
                    if(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
                        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xT")
                    else()
                        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -x0")
                    endif()
                else()
                    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xP")
                endif()
            else()
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xW")
            endif()
        endif()
        if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES i%86)
            if(COMMAND "grep sse2 /proc/cpuinfo 2>/dev/null")
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xN")
            endif()
        endif()
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -ansi_alias")
        if(WITH_PROFILING)
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")
            set(ELFLAGS "ELFLAGS -pg")
        endif()
        if(${MPIPROF} STREQUAL true)
          #if(${MPI} STREQUAL mpich2)
          #  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,--export-dynamic")
          #  set(CMAKE_C_FLAGS_DEBUG "CMAKE_C_FLAGS_DEBUG -Wl,--export-dynamic")
          #endif()
        endif()
    endif()
  
  if(${CC} MATCHES xlc%)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qinfo=gen:ini:por:pro:trd:tru:use") #TODO line303
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -q${ABI} -qarch=auto -qhalt=e")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qinitauto=7F")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Dunix")
  endif()
  
  #if(${CC} STREQUAL cc)
  #  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g")
  #  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
  #  if(${PROF} STREQUAL true)
  #    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")   
  #  endif()
  #endif()
  
  if(CMAKE_COMPILER_IS_GNUFortran)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -pipe -m${ABI} -fno-second-underscore -Wall -x f95-cpp-input")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree-line-length-132")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fmax-identifier-length=63")
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fPIC")
    if(${MACHNAME} STREQUAL x86_64)
      if(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -march=nocona")
      endif()
    endif()
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -fbounds-check")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3 -Wuninitialized -funroll-all-loops")
    if(${PROF} STREQUAL false)
      if((${INSTRUCTION} STREQUAL i686) OR (${INSTRUCTION} STREQUAL x86_64))
        set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -momit-leaf-frame-pointer")   
      endif()
    else()
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")
      set(ELFLAGS "ELFLAGS -pg")
    endif()
  endif()
  
  if(CMAKE_Fortran_COMPILER_ID STREQUAL G95)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-second-underscore -Wall -m${ABI} -std=f2003")
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fPIC")
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -fbound-check")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3 -Wuninitialized -funroll-all-loops")
    set(ELFLAGS "ELFLAGS -m${ABI}")
  endif()
  
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -cpp -warn all -m${ABI}")
    if(${MACHNAME} STREQUAL x86_64)
      if(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        if(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
          if(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xT")
          else()
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -x0")
          endif()
        else()
          set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xP")
        endif()
      else()
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xW")
      endif()
    endif()
    if(${MACHINE} MATCHES i%86)
      if(COMMAND "grep sse2 /proc/cpuinfo 2>/dev/null")
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xN")
      endif()
    endif()  
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -check all -traceback -debug all")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
    if(not(${PROF} STREQUAL false))
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")   
      set(ELFLAGS "${ELFLAGS} -pg")
      set(ELFLAGS "ELFLAGS -pg")
    endif()
    if(${MPIPROF} STREQUAL true)
      #if(${MPI} STREQUAL mpich2)
      #  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wl,--export-dynamic")
      #  set(CMAKE_Fortran_FLAGS_DEBUG "CMAKE_Fortran_FLAGS_DEBUG -Wl,--export-dynamic")
      #else()
      #  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -tcollect")
      #endif()
    endif()
    set(ELFLAGS "${ELFLAGS} -nofor_main -m${ABI} -traceback")
  endif()
  
  if(CMAKE_Fortran_COMPILER MATCHES xlf%)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qarch=auto -qhalt=e -qextname -qsuffix=cpp=f90") 
    set(EFLAGS "${EFLAGS} -q${ABI}")
    if(${ABI} STREQUAL 64)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qwarn64")
    endif()
    if(${DEBUG} STREQUAL false)
      set(MP_FLGS "-qsmp=omp")
    else()
      set(MP_FLGS "-qsmp=omp:noopt")
    endif()
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qextchk -qinitauto=7FF7FFFF")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
  endif()
  
  if(CMAKE_Fortran_COMPILER STREQUAL ftn)
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -g") 
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
    if(${PROF} STREQUAL true)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")   
      set(ELFLAGS "${ELFLAGS} -pg")
    endif()
  endif()
   
  set(ELFLAGS "${ELFLAGS} -static-libgcc")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBSD_TIMERS")

#######################################################################
elseif (CMAKE_HOST_SYSTEM_NAME STREQUAL Windows)
 #TODO ?

#######################################################################
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
    message(STATUS "===${FC}==${ABI}==${PROF}===${INSTRUCTION}") 
    if(CMAKE_COMPILER_IS_GNUFortran)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -pipe -m${ABI} -fno-second-underscore -Wall -x f95-cpp-input")
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree-line-length-132")
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fmax-identifier-length=63")
        set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fPIC")
        if(${MACHNAME} STREQUAL x86_64)
            if(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -march=nocona")
        endif()
    endif()
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -fbounds-check")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3 -Wuninitialized -funroll-all-loops")
    if(NOT WITH_PROFILING)
        if((${INSTRUCTION} STREQUAL i686) OR (${INSTRUCTION} STREQUAL x86_64))
            set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -momit-leaf-frame-pointer")   
        endif()
    else()
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")
        set(ELFLAGS "ELFLAGS -pg")
    endif()

#######################################################################
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL aix)
  #if(${MP} MATCHES false)
  #  set(${FC} mpxlf95)
  #  set(${CC} xlc)
  #else()
  #  set(${FC} mpxlf95_r)
  #  set(${CC} xlc_r)
  #endif()
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qsuffix=cpp=f90 -qnoextname")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qinfo=gen:ini:por:pro:trd:tru:use") # TODO line 455
  set(ELFLAGS "${ELFLAGS} -q${ABI}")
  set(CFE_FLGS "${CFE_FLGS} -q${ABI} -qarch=auto -qhalt=e")
  set(L_FLGS "${L_FLGS} -b${ABI}")
  set(D_FLGS "-G -bexpall -bnoentry")
  if(${ABI} STREQUAL 32)
    set(ELFLAGS "${ELFLAGS} -bmaxdata:0x80000000/dsa")
  else()
    set(CF_FLGS "${CF_FLGS} -qwarn64")
    set(ELFLAGS "${ELFLAGS} -bmaxdata:0x0000100000000000")
  endif()
  if(${DEBUG} STREQUAL false)
    set(MP_FLGS "-qsmp=omp")
  else()
    set(MP_FLGS "-qsmp=omp:noopt")
  endif()
  set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qextchk")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qextchk")
  set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -qinitauto=7FF7FFFF")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -qinitauto=7F")
  set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -qnoignerrno")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBSD_TIMERS")
endif()
endif()
