def get_compatibility(user_a_data, user_b_data):
    """
    Calculates the compatibility rate between two given users
    
    Args: 
        user_a_data (dict): A dict containing interests of one user `a`
        user_b_data (dict): A dict containing interests of another user `b`

    Returns: 
        float: The percentage of interests that two users have in common
    
    """

    interests_a = set(user_a_data['interests'])
    interests_b = set(user_b_data['interests'])

    common_interests = interests_a.intersection(interests_b)

    score = len(common_interests) / len(max(interests_a, interests_b))
    
    return score
