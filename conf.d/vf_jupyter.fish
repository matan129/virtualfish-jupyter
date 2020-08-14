function __vfcustom_kernel_name
    set -l virtualenv_name (basename $VIRTUAL_ENV)
    set -l python_major (python -c 'import sys; print(sys.version_info[0])')
    echo "python$python_major""_""$virtualenv_name"
end


function __vf_register_jupyter --description "Register Jupyter kernel"
    if test -z "$VIRTUAL_ENV"
        echo "Virtualenv not activated"
        return 1
    end

    set -l virtualenv_name (basename $VIRTUAL_ENV)
    set -l python_version (python --version)
    
    if not pip show ipykernel > /dev/null 2>&1
        pip install ipykernel
    end

    python -m ipykernel install --user --name (__vfcustom_kernel_name) --display-name "$python_version ($virtualenv_name)"
end


function __vf_unregister_jupyter --on-event virtualenv_will_remove --description "Unregister Jupyter kernel"
    set -l venv ""
    if test -z "$argv[1]"
        if test -z "$VIRTUAL_ENV"
            echo "Virtualenv name is requried"
            return 1
        else
            set venv (basename $VIRTUAL_ENV)
        end
    else
        set venv $argv[1]
    end


    set -l old_virtual_env "$VIRTUAL_ENV"
    vf activate $venv
    
    set -l kernel_name (__vfcustom_kernel_name)

    if test -z "$old_virtual_env"
        vf deactivate
    else
        vf activate (basename $old_virtual_env)
    end
    
    if jupyter kernelspec list | grep "$kernel_name " > /dev/null 2>&1
        echo "Unregistering Jupyter kernel $kernel_name"
        echo y | jupyter kernelspec uninstall $kernel_name > /dev/null 2>&1
    end
end
