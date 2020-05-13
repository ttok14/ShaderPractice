using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomRotation : MonoBehaviour
{
    Transform ts;
    public float speed=5;
    public bool x = true, y = true, z = true;

    // Start is called before the first frame update
    void Start()
    {
        ts = GetComponent<Transform>();    
    }

    // Update is called once per frame
    void Update()
    {
        ts.Rotate(x ? speed * Time.deltaTime: 0, y ? speed * Time.deltaTime: 0, z ? speed * Time.deltaTime: 0);
    }
}
