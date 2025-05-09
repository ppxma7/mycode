import numpy as np

def compute_ernst_scaling(TRs, T1=2132, reference_TR=2.0):
    """
    Computes the Ernst angle (degrees), signal amplitude, and scale factor relative to reference_TR.
    
    Parameters:
        TRs (list of float): List of TRs in seconds
        T1 (float): T1 relaxation time in ms (default 2132 ms)
        reference_TR (float): Reference TR to scale against (default 2.0s)

    Returns:
        dict: A dictionary mapping TR to a tuple (Ernst angle in degrees, signal, scale factor)
    """
    results = {}
    def ernst_signal(TR):
        E1 = np.exp(-TR / T1)
        theta_rad = np.arccos(E1)
        signal = (np.sin(theta_rad) * (1 - E1)) / (1 - np.cos(theta_rad) * E1)
        return signal, np.degrees(theta_rad)

    # Compute reference signal
    ref_signal, _ = ernst_signal(reference_TR)

    for tr in TRs:
        signal, angle_deg = ernst_signal(tr)
        scale_factor = signal / ref_signal
        results[tr] = (angle_deg, signal, scale_factor)

    return results


TRs = [2.0, 1.33, 1.0, 0.66]
ernst_results = compute_ernst_scaling(TRs)

for tr, (angle, signal, scale) in ernst_results.items():
    print(f"TR = {tr:.2f}s → Ernst angle = {angle:.2f}°, Signal = {signal:.5f}, Scale factor = {scale:.4f}")

