# Not working as expected
class Notes(Dashboard.Module):
    """Simple user-defined notes."""

    def __init__(self):
        self.notes = []

    def label(self):
        return 'Notes'

    def lines(self, term_width, term_height, style_changed):
        out = []
        for note in self.notes:
            out.append(note)
            # if self.divider:
            #     out.append(divider())
        return out[:-1] if self.divider else out

    def add(self, arg):
        if arg:
            self.notes.append(arg)
        else:
            raise Exception('Cannot add an empty note')

    def clear(self, arg):
        self.notes = []

    def commands(self):
        return {
            'add': {
                'action': self.add,
                'doc': 'Add a note.'
            },
            'clear': {
                'action': self.clear,
                'doc': 'Remove all the notes.'
            }
        }

    def attributes(self):
        return {
            'divider': {
                'doc': 'Divider visibility flag.',
                'default': True,
                'type': bool
            }
        }
