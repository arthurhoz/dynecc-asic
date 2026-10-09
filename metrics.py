import json
import sys
from pathlib import Path

filename = 'runs/RUN_2026-10-08_16-44-10/final/metrics.json'

metrics = {
    'power': {
        'total': 0.,
        'leakage': 0.,
        'switching': 0.,
        'internal': 0.,
    },
    'amount': {
        'stdcell': 0,
        'nets': 0,
        'vias': 0,
        'wirelength': 0,
        'io_pins': 0
    },
    'area': {
        'stdcell': 0.,
        'core': 0.,
        'die': 0.
    },
    'dimensions': {
        'core': [0., 0.],
        'die': [0., 0.]
    }
}

def calculate_dimensions(data: str):
    values = list(map(float, data.split()))

    return [values[2] - values[0], values[3] - values[1]]

with open(filename, 'r') as file:
    data = json.load(file)

    power = metrics['power']
    power['total'] = data['power__total']
    power['leakage'] = data['power__leakage__total']
    power['switching'] = data['power__switching__total']
    power['internal'] = data['power__internal__total']

    amount = metrics['amount']
    amount['stdcell'] = data['design__instance__count__stdcell']
    amount['vias'] = data['route__net']
    amount['nets'] = data['route__vias']
    amount['wirelength'] = data['route__wirelength']
    amount['io_pins'] = data['design__io']

    area = metrics['area']
    area['stdcell'] = data['design__instance__area__stdcell']
    area['core'] = data['design__core__area']
    area['die'] = data['design__die__area']

    dimensions = metrics['dimensions']
    dimensions['core'] = calculate_dimensions(data['design__core__bbox'])
    dimensions['die'] = calculate_dimensions(data['design__die__bbox'])

print(metrics)
