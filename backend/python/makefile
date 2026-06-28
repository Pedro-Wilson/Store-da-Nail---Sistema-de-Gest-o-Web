PYTHON = python3
VENV = .venv
VENV_PYTHON = $(VENV)/bin/python
VENV_PIP = $(VENV)/bin/pip
STREAMLIT = $(VENV)/bin/streamlit

.PHONY: run install clean

$(VENV):
	$(PYTHON) -m venv $(VENV)

install: $(VENV)
	$(VENV_PIP) install --upgrade pip
	$(VENV_PIP) install -r requirements.txt

run: install
	$(STREAMLIT) run app.py

clean:
	rm -rf $(VENV)