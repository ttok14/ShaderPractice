using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YoutubeCourse_Shoreline : MonoBehaviour
{
    private void Update()
    {
        /// Plane 에 마우스 hit 체크해서 Shader Global Vector 설정 
        /// 설정된 Value 는 BasicTest05_MouseGlow 쉐이더에서 사용 

        var ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (new Plane(Vector3.up, Vector3.zero).Raycast(ray, out var enterDist))
        {
            Vector3 worldMousePos = ray.GetPoint(enterDist);
            Shader.SetGlobalVector("_MousePos", worldMousePos);
        }
    }
}
