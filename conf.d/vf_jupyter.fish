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

function __vfcustom_setup_event_handlers --on-event virtualenv_will_remove
    set i 0
    for venv in (vf ls)
        eval "function __vfcustom_temp_unregister_$i --on-event 'virtualenv_will_remove:$venv'
            __vf_unregister_jupyter $venv
        end
        "
        set i (math $i + 1)
    end
end

function __vfcustom_destroy_event_handlers --on-event virtualenv_did_remove
    for f in (functions --all | grep __vfcustom_temp_unregister_)
        functions -e $f
    end
end


function __vf_unregister_jupyter --description "Unregister Jupyter kernel"
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
