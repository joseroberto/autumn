from setuptools import setup

setup(
    name='autman',
    packages=['app'],
    include_package_data=True,
    install_requires=[
        'flask',
        'paramiko',
        'pyyaml',
        'Flask-Login'
    ],
    setup_requires=[
        'pytest-runner',
    ],
    tests_require=[
        'pytest',
    ],
)
