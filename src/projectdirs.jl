"""
Shamelessly taken from DrWaston.jl
"""

is_standard_julia_project() = Base.active_project() == Base.load_path_expand("@v#.#")

function projectdir()
    is_standard_julia_project() && @error "Using the standard Julia project."
    dirname(Base.active_project())
end

projectdir(args...) = joinpath(projectdir(), args...)

for dir_type in ("data", "src", "plots", "scripts", "papers")
    function_name = Symbol(dir_type * "dir")
    @eval $function_name(args...) = projectdir($dir_type, args...)
end
