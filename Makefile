
###
### Allows one to publish arbitrary .deb files
###
### use as:
###    $ make deb-publish some-package-name_1.0-1foo.deb wheezy
###
### works the same as the existing package specific publish targets.


# provide a publish target for arbitrary .debs
ifeq (deb-publish,$(firstword $(MAKECMDGOALS)))
DEBFILE:=$(word 2,$(MAKECMDGOALS))
CHANGESFILE:=$(addsuffix .changes,$(basename $(DEBFILE)))
PUBLISH_DISTRO:=$(word 3,$(MAKECMDGOALS))
# dummy definitions to satisfy Makefile.base
NAME:=_
VERSION:=_
OVERRIDES=$(DEBFILE) $(SRCDIR) clean distclean
include Makefile.base
# and dummy targets to satisfy make
$(eval $(PUBLISH_DISTRO):;@:)
$(eval $(DEBFILE):;@:)
$(eval $(call ENSUREVAR,PUBLISH_DISTRO))
endif


$(CHANGESFILE):
	./generate_changes.py $(DEBFILE) $(PUBLISH_DISTRO) $(CHANGESFILE)

deb-publish: $(CHANGESFILE) publish




