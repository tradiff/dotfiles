# Overrides the tide default. Shows only the icon with no version number or venv name.

function _tide_item_python
    if test -n "$VIRTUAL_ENV"; or path is .python-version Pipfile __init__.py pyproject.toml requirements.txt setup.py
        _tide_print_item python $tide_python_icon' '
    end
end
