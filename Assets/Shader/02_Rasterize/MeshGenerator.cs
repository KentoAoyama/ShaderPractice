using UnityEngine;

[ExecuteInEditMode]
public class MeshGenerator : MonoBehaviour
{
    [SerializeField]
    private Material _rasterizeMat;

    void Start()
    {
        MeshRenderer meshRenderer = null;
        if (gameObject.TryGetComponent<MeshRenderer>(out _) == false)
        {
            meshRenderer = gameObject.AddComponent<MeshRenderer>();
        }
        if (meshRenderer != null)
        {
            meshRenderer.material = _rasterizeMat;
        }

        Mesh mesh = new()
        {
            vertices = new Vector3[]
            {
                new (-0.5f, -0.5f, 0f), // 0
                new (0.5f, -0.5f, 0f),  // 1
                new (0.5f, 0.5f, 0f),   // 2
                new (-0.5f, 0.5f, 0f)   // 3
            },

            colors = new Color[]
            {
                Color.red,
                Color.blue,
                Color.white,
                Color.black
            },

            triangles = new int[]
            {
                0, 2, 1,
                0, 3, 2
            }
        };

        mesh.RecalculateBounds();

        MeshFilter meshFilter = null;
        if (gameObject.TryGetComponent<MeshFilter>(out _) == false)
        {
            meshFilter = gameObject.AddComponent<MeshFilter>();
        }
        if (meshFilter != null)
        {
            meshFilter.mesh = mesh;
        }
    }
}
