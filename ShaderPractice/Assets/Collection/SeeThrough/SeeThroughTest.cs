using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeeThroughTest : MonoBehaviour
{
    public GameObject target;
    public float speed = 0.2f;

    // Start is called before the first frame update
    IEnumerator Start()
    {
        int sign = 1;
        float time = 0;

        while (true)
        {
            target.transform.position += new Vector3(speed * Time.deltaTime * sign, 0, 0);
            time += Time.deltaTime;
            if (time > 1.5f)
            {
                sign *= -1;
                time -= 1.5f;
            }

            yield return null;
        }
    }
}
