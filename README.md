# virtualfish-jupyter

A convenient helper to install new Jupyter kernels with [virtualfish](https://github.com/justinmayer/virtualfish)-managed virtualenvs.

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher) (recommended):

```console
fisher add matan129/virtualfish-jupyter
```

## Usage

After installation, when in a new virtualenv, you can run

```console
vf register_jupyter
```

That will install `ipykernel` (if needed) and will register a Jupyter kernel for that virtualenv.
This means that you'll be able to open Jupyter notebooks on your virtualenv!

![Jupyter kernel list](https://user-images.githubusercontent.com/1483099/90234815-f6450d00-de28-11ea-9bdf-0f0ab2bb4d2e.png)


When the virtualenv is destroyed by `vf rm my-venv`, the kernel will be deleted automatically. This can also done manually by

```console
vf unregister_jupyter  # when the virtualenv is activated
```

or

```console
vf unregister_jupyter my_venv
```
