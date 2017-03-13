# In general this class should only be used by board layers
# that keep their machine-readable-workbook in the skeleton repository.

inherit allarch
inherit setuptools
inherit pythonnative
inherit skeleton-rev
inherit obmc-phosphor-license

HOMEPAGE = "http://github.com/KenChenIEC/skeleton"

PROVIDES += "virtual/obmc-inventory-data"
RPROVIDES_${PN} += "virtual-obmc-inventory-data"

SKELETON_BRANCH = "dev-lanyang"
DEPENDS += "python"
SRC_URI += "${SKELETON_URI};subpath=configs;branch=${SKELETON_BRANCH}"
S = "${WORKDIR}/configs"

python() {
	machine = d.getVar('MACHINE', True).capitalize() + '.py'
	d.setVar('_config_in_skeleton', machine)
}

do_make_setup() {
        cp ${S}/${_config_in_skeleton} \
                ${S}/obmc_system_config.py
        cat <<EOF > ${S}/setup.py
from distutils.core import setup

setup(name='${BPN}',
    version='${PR}',
    py_modules=['obmc_system_config'],
    )
EOF
}

addtask make_setup after do_patch before do_configure
