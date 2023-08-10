import re


class InjectionThreatError(Exception):
    """Exception raised for potential injection threats."""

    def __init__(self, message):
        self.message = message
        super().__init__(self.message)


def unpack_query_results(docs) -> list:

    return [d.to_dict() for d in docs]


def format_phone_number(phone_number: str, exit_code: str = '') -> list:

    if phone_number.startswith('+'):
        exit_code = ''

    return f'{exit_code}{phone_number}'.replace(' ', '').replace('-', '')


def sanitize_input(input):
    """Sanitize user input"""
    
    # Remove any whitespace characters from the beginning and end of the string
    input = input.strip()
    
    # Remove any SQL keywords or special characters from the string
    input = re.sub(r'[;\'"\/()\[\]]', '', input)
    
    return input


def thwart_injection_attempt(input_string):
    """Check if the input string contains SQL code or potential SQL injection patterns"""
    
    # Check for common SQL keywords or statements
    sql_keywords = ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'ALTER', 'CREATE']
    for keyword in sql_keywords:
        if keyword in input_string.upper():
            return True
    
    # Check for semicolon followed by additional code
    if re.search(r';\s*\w', input_string):
        return True
    
    # Check for typical SQL injection patterns
    injection_patterns = [r'\bUNION\b', r'\bOR\b', r'\bAND\b', r'\bSELECT\s.*\bFROM\b', r'\bWHERE\b']
    for pattern in injection_patterns:
        if re.search(pattern, input_string.upper()):
            raise InjectionThreatError("Potential threat detected")
    
    return input_string