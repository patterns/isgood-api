import pytest

def pytest_addoption(parser):
    parser.addoption("--base", action="store")

@pytest.fixture(scope='session')
def base(request):
    base_value = request.config.option.base
    if base_value is None:
        pytest.skip()
    return base_value

