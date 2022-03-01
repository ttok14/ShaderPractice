using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YoutubeCourse_Shoreline : MonoBehaviour
{
    private void Update()
    {
        /// Plane �� ���콺 hit üũ�ؼ� Shader Global Vector ���� 
        /// ������ Value �� BasicTest05_MouseGlow ���̴����� ��� 

        var ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (new Plane(Vector3.up, Vector3.zero).Raycast(ray, out var enterDist))
        {
            Vector3 worldMousePos = ray.GetPoint(enterDist);
            Shader.SetGlobalVector("_MousePos", worldMousePos);
        }
    }
}
