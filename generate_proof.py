import json
import sys
from eth_hash.auto import keccak

def to_bytes(data):
    if isinstance(data, str):
        return bytes.fromhex(data[2:] if data.startswith('0x') else data)
    return data

def create_leaf_hash(target, function_selector, decoder_and_sanitizer, value_non_zero, params):
    packed_params = b''.join(to_bytes(param) for param in params)
    leaf_data = to_bytes(decoder_and_sanitizer) + to_bytes(target) + (b'\x01' if value_non_zero else b'\x00') + to_bytes(function_selector) + packed_params
    print(f"\nDetailed leaf data:")
    print(f"Decoder and sanitizer: {decoder_and_sanitizer}")
    print(f"Target: {target}")
    print(f"Value non-zero: {value_non_zero}")
    print(f"Function selector: {function_selector}")
    print(f"Params: {params}")
    print(f"Leaf data (hex): {leaf_data.hex()}")
    return '0x' + keccak(leaf_data).hex()

def hash_pair(a, b):
    a = to_bytes(a)
    b = to_bytes(b)
    return '0x' + keccak(min(a, b) + max(a, b)).hex()

def generate_proof(leaf_hash, leaves):
    tree = [leaves]
    while len(tree[-1]) > 1:
        new_level = []
        for i in range(0, len(tree[-1]), 2):
            if i + 1 < len(tree[-1]):
                new_level.append(hash_pair(tree[-1][i], tree[-1][i+1]))
            else:
                new_level.append(tree[-1][i])
        tree.append(new_level)
    
    proof = []
    index = leaves.index(leaf_hash)
    for level in tree[:-1]:
        if index % 2 == 0:
            if index + 1 < len(level):
                proof.append(level[index + 1])
        else:
            proof.append(level[index - 1])
        index //= 2
    
    return proof, tree[-1][0]

def main(json_file):
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Use the correct values for the approve function
    target = "0x4132aCf612637A3B821427C92312e19e7bae84f2" # Default Collateral contract
    function_selector = "0x095ea7b3" # approve(address,uint256)
    decoder_and_sanitizer = "0x4Fb29DE25f853f0A4eb5d1dE45883D706D784488" # DecoderAndSanitizer contract
    value_non_zero = False
    params = ["0x0854a63185b0CFD013E8cE389C8B0E5d7C1934C9"] # MigratableEntityProxy of Core Vault contract

    leaf_hash = create_leaf_hash(target, function_selector, decoder_and_sanitizer, value_non_zero, params)

    print(f"\nGenerated leaf hash: {leaf_hash}")
    print(f"Expected leaf hash: 0x0cf5053bc236924b57c662278d723d9275ce38af8dc17b11b402d6d096659444")
    print(f"Match: {'Yes' if leaf_hash == '0x0cf5053bc236924b57c662278d723d9275ce38af8dc17b11b402d6d096659444' else 'No'}")

    leaves = [leaf['LeafDigest'] for leaf in data['leafs']]
    proof, root = generate_proof(leaf_hash, leaves)

    print(f"\nMerkle Proof:")
    for i, p in enumerate(proof):
        print(f"  {i}: {p}")
    print(f"\nMerkle Root: {root}")
    print(f"Expected Root: {data['metadata']['ManageRoot']}")
    print(f"Root Match: {'Yes' if root == data['metadata']['ManageRoot'] else 'No'}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <json_file_path>")
        sys.exit(1)

    json_file = sys.argv[1]
    main(json_file)
