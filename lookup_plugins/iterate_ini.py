from __future__ import (absolute_import, division, print_function)
from ansible.module_utils.six.moves import configparser

from ansible.errors import AnsibleError, AnsibleParserError
from ansible.plugins.lookup import LookupBase
__metaclass__ = type

DOCUMENTATION = """
      lookup: iterate_ini
        author: Will
        short_description: read ini file contents
        description:
            - This lookup returns the contents from an ini file on the Ansible controller's file system.
        options:
          _terms:
            description: path(s) of file(s) to read
            required: True
"""

try:
    from __main__ import display
except ImportError:
    from ansible.utils.display import Display
    display = Display()


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):

        ret = []
        for term in terms:
            display.debug("File lookup term: %s" % term)

            # Find the file in the expected search path, using a class method
            # that implements the 'expected' search path for Ansible plugins.
            lookupfile = self.find_file_in_search_path(variables, 'files', term)

            display.vvvv(u"File lookup using %s as file" % lookupfile)
            try:
                if lookupfile:
                    config = configparser.ConfigParser()
                    config.optionxform = str
                    config.read(lookupfile)
                    for section in config.sections():
                        for name, value in config.items(section):
                            ret.append({'section': section,
                                        'option': name,
                                        'value': value})
                else:
                    # Always use ansible error classes to throw 'final' exceptions,
                    # so the Ansible engine will know how to deal with them.
                    # The Parser error indicates invalid options passed
                    raise AnsibleParserError()
            except AnsibleParserError:
                raise AnsibleError("could not locate file in lookup: %s" % term)

        return ret
